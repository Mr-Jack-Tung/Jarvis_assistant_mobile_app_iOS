//
//  OpenAIChat.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import Foundation

enum OpenAIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case apiError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL for OpenAI API."
        case .noData:
            return "No data received from OpenAI API."
        case .decodingError(let error):
            return "Failed to decode API response: \(error.localizedDescription)"
        case .apiError(let message):
            return "OpenAI API Error: \(message)"
        case .unknown:
            return "An unknown error occurred with OpenAI API."
        }
    }
}

class OpenAIChat {
    private let apiKey: String
    private let apiURL = "https://api.openai.com/v1/chat/completions"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func sendMessage(message: String, model: String = "o4-mini-2025-04-16") async throws -> String {
        guard let url = URL(string: apiURL) else {
            throw OpenAIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let messages = [
            ["role": "user", "content": message]
        ]
        let body: [String: Any] = [
            "model": model,
            "messages": messages
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.unknown
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let errorResponse = try? JSONDecoder().decode(OpenAIAPIErrorResponse.self, from: data) {
                throw OpenAIError.apiError(errorResponse.error.message)
            } else {
                throw OpenAIError.apiError("HTTP Status Code: \(httpResponse.statusCode)")
            }
        }

        do {
            let decodedResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
            return decodedResponse.choices.first?.message.content ?? "No response content."
        } catch {
            throw OpenAIError.decodingError(error)
        }
    }
}

// MARK: - OpenAI API Response Models

struct OpenAIChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: MessageContent
    let logprobs: JSONNull?
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message, logprobs
        case finishReason = "finish_reason"
    }
}

struct MessageContent: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct OpenAIAPIErrorResponse: Codable {
    let error: OpenAIAPIError
}

struct OpenAIAPIError: Codable {
    let message: String
    let type: String
    let param: JSONNull?
    let code: String?
}

// MARK: - Helper for JSONNull (if API returns null for some fields)
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

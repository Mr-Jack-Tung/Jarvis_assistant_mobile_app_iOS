//
// APIProvider.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import Foundation
import GoogleGenerativeAI // Import for Gemini API

protocol APIProvider {
    func sendMessage(prompt: String, imageData: Data?, fileData: Data?, context: [Message]) async throws -> String
}

class GeminiProvider: APIProvider {
    private let apiKey: String
    private let model: GenerativeModel
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.model = GenerativeModel(name: "gemini-2.5-flash-preview-05-20", apiKey: apiKey)
    }
    
    func sendMessage(prompt: String, imageData: Data?, fileData: Data?, context: [Message]) async throws -> String {
        var history: [ModelContent] = []
        for message in context {
            if message.isUser {
                if let content = try? ModelContent(role: "user", parts: [message.text]) {
                    history.append(content)
                }
            } else {
                if let content = try? ModelContent(role: "model", parts: [message.text]) {
                    history.append(content)
                }
            }
        }
        
        var parts: [ModelContent.Part] = []
        if !prompt.isEmpty {
            parts.append(.text(prompt))
        }
        
//        if let imageData = imageData {
//            parts.append(.jpeg(imageData))
//        }
//        
//        if let fileData = fileData {
//            // For file data, you might need to specify the MIME type if Gemini supports it
//            // For now, treating it as raw data or assuming a generic type.
//            // A more robust solution would involve identifying the file type.
//            parts.append(.data(mimetype: "application/octet-stream", fileData))
//        }
        
        let chat = model.startChat(history: history)
        
        // Pass the parts array as variadic arguments
        let response = try await chat.sendMessage(history)
        
        guard let text = response.text else {
            throw APIProviderError.noResponseText
        }
        return text
    }
}

class OpenAIProvider: APIProvider {
    private let openAIChat: OpenAIChat
    
    init(apiKey: String) {
        self.openAIChat = OpenAIChat(apiKey: apiKey)
    }
    
    func sendMessage(prompt: String, imageData: Data?, fileData: Data?, context: [Message]) async throws -> String {
        // OpenAI's chat completion API primarily uses text.
        // For now, imageData and fileData are not directly supported in this integration.
        // If needed, these would require a different approach (e.g., Vision API for images).
        
        // You might want to format the context messages for OpenAI if needed,
        // but for a simple prompt, we'll just send the latest prompt.
        
        do {
            let response = try await openAIChat.sendMessage(message: prompt)
            return response
        } catch let error as OpenAIError {
            throw APIProviderError.openAIError(error.localizedDescription)
        } catch {
            throw APIProviderError.unknownError(error.localizedDescription)
        }
    }
}

enum APIProviderError: Error, LocalizedError {
    case noResponseText
    case openAIError(String)
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .noResponseText:
            return "No response text received from the API."
        case .openAIError(let message):
            return "OpenAI API Error: \(message)"
        case .unknownError(let message):
            return "An unknown error occurred: \(message)"
        }
    }
}

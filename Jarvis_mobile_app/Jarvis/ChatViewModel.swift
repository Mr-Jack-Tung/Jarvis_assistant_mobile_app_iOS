//
//  ChatViewModel.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import Foundation
import SwiftUI
import PhotosUI // Import for PhotosPickerItem

// Chat session structure for history
struct ChatSessionHistory: Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var messageCount: Int
}

class ChatViewModel: ObservableObject {
    @AppStorage("apiProvider") private var apiProvider: String = "gemini"
    @AppStorage("apiKey") private var apiKey: String = ""
    
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isTyping = false
    @Published var selectedImageItem: NSItemProvider? // For PhotosPicker binding
    @Published var selectedImageData: Data? // To store the actual image data
    @Published var selectedFileData: Data? // To store the actual file data
    @Published var selectedFileName: String? // To display the selected file name
    @Published var chatSessions: [ChatSessionHistory] = [] // Add chat sessions array
    @Published var currentLanguage: AppLanguage = .english // Track current language
    
    // Use lazy var to initialize the provider only when first accessed
    private lazy var geminiProvider: APIProvider = {
        return GeminiProvider(apiKey: apiKey)
    }()
    
    init() {
        // Add some sample chat sessions for testing
        self.chatSessions = [
            ChatSessionHistory(name: "Hội thoại về AI", date: Date().addingTimeInterval(-86400), messageCount: 12),
            ChatSessionHistory(name: "Hỏi đáp về Swift", date: Date().addingTimeInterval(-172800), messageCount: 8),
            ChatSessionHistory(name: "Trợ giúp dự án", date: Date().addingTimeInterval(-259200), messageCount: 15),
            ChatSessionHistory(name: "Tìm hiểu SwiftUI", date: Date().addingTimeInterval(-345600), messageCount: 10)
        ]
    }

    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty || selectedImageData != nil || selectedFileData != nil else { return }

        // Check if API key is empty and show error if it is
        if apiKey.isEmpty {
            let errorMsg = Message(text: "Error: \("no_api_key_error".localized(currentLanguage))", isUser: false)
            messages.append(errorMsg)
            return
        }
        
        // Create a new provider with the current API key to ensure we're using the latest key
        self.geminiProvider = GeminiProvider(apiKey: apiKey)

        let userMsg = Message(text: inputText, isUser: true, imageData: selectedImageData, fileName: selectedFileName)
        messages.append(userMsg)

        let prompt = inputText
        inputText = ""
        isTyping = true

        Task {
            do {
                let botResponse = try await geminiProvider.sendMessage(
                    prompt: prompt,
                    imageData: selectedImageData,
                    fileData: selectedFileData,
                    context: messages
                )
                DispatchQueue.main.async {
                    let botMsg = Message(text: botResponse, isUser: false)
                    self.messages.append(botMsg)
                    self.isTyping = false
                    self.clearAttachments()
                }
            } catch {
                DispatchQueue.main.async {
                    let errorMsg = Message(text: "Error: \(error.localizedDescription)", isUser: false)
                    self.messages.append(errorMsg)
                    self.isTyping = false
                    self.clearAttachments()
                }
            }
        }
    }
    
    func handleImageSelection(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            selectedImageData = data
            // Optionally, you can add a message to the chat indicating an image was selected
            // For now, it will be sent with the next text message.
        }
    }
    
    func handleFileSelection(_ fileURL: URL) {
        do {
            // Securely access the file if it's a security-scoped bookmark
            let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
            
            selectedFileData = try Data(contentsOf: fileURL)
            selectedFileName = fileURL.lastPathComponent
            
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
            // Optionally, you can add a message to the chat indicating a file was selected
            // For now, it will be sent with the next text message.
        } catch {
            print("Error reading file: \(error.localizedDescription)")
            selectedFileData = nil
            selectedFileName = nil
        }
    }
    
    private func clearAttachments() {
        selectedImageItem = nil
        selectedImageData = nil
        selectedFileData = nil
        selectedFileName = nil
    }
}

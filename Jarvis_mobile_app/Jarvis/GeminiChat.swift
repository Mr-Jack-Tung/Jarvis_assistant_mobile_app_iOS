//
//  GeminiChat.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import Foundation
import SwiftUI
import GoogleGenerativeAI

struct GeminiChatView: View {
    @StateObject var viewModel = GeminiChatViewModel()
    
    var body: some View {
        VStack {
            Text("Gemini Chat")
                .font(.title)
                .padding()

            ForEach(viewModel.messages.indices, id: \.self) { index in
                let msg = viewModel.messages[index]
                Text(msg.text)
                    .padding()
                    .background(msg.isUser ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            
            HStack {
                TextField("Message", text: $viewModel.inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                }
            }
        }
    }
}

class GeminiChatViewModel: ObservableObject {
    @Published var messages: [(text: String, isUser: Bool)] = []
    @Published var inputText: String = ""
    @AppStorage("apiKey") var apiKey: String = "" // Get API key from AppStorage
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        // Add user message
        messages.append((inputText, true))
        let userMessage = inputText
        inputText = ""
        
        // Get context from last 3 messages
        // let context = messages.suffix(3).map { $0.text }.joined(separator: "\n")
        
        Task {
            do {
                let model = GenerativeModel(name: "gemini-2.5-flash-preview-05-20", apiKey: apiKey)
                let history: [ModelContent] = try messages.suffix(3).map {
                    try ModelContent(role: $0.isUser ? "user" : "model", parts: [$0.text])
                }
                let chat = model.startChat(history: history)
                let response = try await chat.sendMessage(userMessage)

                if let text = response.text {
                    DispatchQueue.main.async {
                        self.messages.append((text, false))
                    }
                }
            } catch {
                    DispatchQueue.main.async {
                        self.messages.append(("Error: \(error.localizedDescription)", false))
                    }
                }
        }
    }
}

//
// SettingsView.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("apiProvider") var apiProvider: String = "gemini"
    @AppStorage("apiKey") var apiKey: String = ""
    @AppStorage("requestLimit") var requestLimit: Int = 60 // Default request limit
    
    @State private var tempProvider = ""
    @State private var tempKey = ""
    @State private var tempRequestLimit: String = ""
    @State private var isValidAPIKey: Bool? = nil
    @State private var validationMessage: String = ""
    @State private var showPasteSheet = false
    @State private var pastedText = ""
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.appLanguage) var appLanguage: Binding<AppLanguage>

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("api_configuration".localized(appLanguage.wrappedValue))) {
                    Picker("api_provider".localized(appLanguage.wrappedValue), selection: $tempProvider) {
                        Text("Gemini").tag("gemini")
                        Text("OpenAI").tag("openai")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            SecureField("api_key".localized(appLanguage.wrappedValue), text: $tempKey)
                                .textContentType(.password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: tempKey) { _, newValue in
                                    validateAPIKey(newValue)
                                }
                            
                            Button(action: {
                                UIPasteboard.general.string.map { pastedText = $0 }
                                showPasteSheet = true
                            }) {
                                Image(systemName: "doc.on.clipboard")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            if let isValid = isValidAPIKey {
                                Image(systemName: isValid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(isValid ? .green : .red)
                                    .font(.title2)
                            }
                        }
                        
                        Text("api_key_tip".localized(appLanguage.wrappedValue))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .alert("paste_api_key".localized(appLanguage.wrappedValue), isPresented: $showPasteSheet) {
                        Button("cancel".localized(appLanguage.wrappedValue), role: .cancel) { }
                        Button("paste".localized(appLanguage.wrappedValue)) {
                            if !pastedText.isEmpty {
                                tempKey = pastedText
                                validateAPIKey(pastedText)
                            }
                        }
                    } message: {
                        Text("paste_api_key_message".localized(appLanguage.wrappedValue))
                    }
                    
                    if !validationMessage.isEmpty {
                        Text(validationMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    TextField("request_limit".localized(appLanguage.wrappedValue), text: $tempRequestLimit)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: saveSettings) {
                        Text("save_settings".localized(appLanguage.wrappedValue))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("api_settings".localized(appLanguage.wrappedValue))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                tempProvider = apiProvider
                tempKey = apiKey
                tempRequestLimit = String(requestLimit)
                validateAPIKey(tempKey) // Validate on appear as well
            }
        }
    }
    
    private func saveSettings() {
        apiProvider = tempProvider
        apiKey = tempKey
        if let limit = Int(tempRequestLimit) {
            requestLimit = limit
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func validateAPIKey(_ key: String) {
        // Placeholder for API key validation logic
        // In a real scenario, this would involve a network request to the API provider
        // For now, let's assume a simple validation (e.g., not empty and a certain length)
        if key.isEmpty {
            isValidAPIKey = nil
            validationMessage = ""
        } else if key.count >= 10 { // Example: minimum length of 10 characters
            isValidAPIKey = true
            validationMessage = "api_key_valid".localized(appLanguage.wrappedValue)
        } else {
            isValidAPIKey = false
            validationMessage = "api_key_invalid".localized(appLanguage.wrappedValue)
        }
    }
}

//
// LanguageManager.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import Foundation
import SwiftUI

enum AppLanguage: String {
    case english = "en"
    case vietnamese = "vi"
    
    var flagEmoji: String {
        switch self {
        case .english: return "🇺🇸"
        case .vietnamese: return "🇻🇳"
        }
    }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .vietnamese: return "Tiếng Việt"
        }
    }
}

// Environment key for language
struct AppLanguageKey: EnvironmentKey {
    static let defaultValue: Binding<AppLanguage> = .constant(.english)
}

extension EnvironmentValues {
    var appLanguage: Binding<AppLanguage> {
        get { self[AppLanguageKey.self] }
        set { self[AppLanguageKey.self] = newValue }
    }
}

// String extension for localization
extension String {
    func localized(_ language: AppLanguage) -> String {
        // In a full implementation, this would use proper Localizable.strings files
        // This is a simplified implementation for demonstration
        let localizedStrings: [AppLanguage: [String: String]] = [
            .english: [
                // Navigation and Menu
                "jarvis_chatbot": "Jarvis Chatbot",
                "new_conversation": "New Conversation",
                "search": "Search",
                "chat_history": "Chat History",
                "guide": "Guide",
                "settings": "Settings",
                "close": "Close",
                
                // Input fields
                "enter_message": "Enter message...",
                
                // Chat history
                "no_conversations": "No conversations",
                "messages": "messages",
                
                // Media selection
                "select_image": "Select Image",
                "take_photo": "Take Photo",
                "select_file": "Select File",
                
                // Alerts
                "camera_not_available": "Camera Not Available",
                "camera_error_message": "This device does not have a camera or camera access is restricted.",
                "no_api_key_error": "No API key provided. Please add your API key in the settings.",
                
                // Settings
                "api_settings": "API Settings",
                "api_configuration": "API Configuration",
                "api_provider": "API Provider",
                "api_key": "API Key",
                "request_limit": "Request Limit (per minute)",
                "save_settings": "Save Settings",
                "api_key_valid": "API Key is valid.",
                "api_key_invalid": "API Key is too short or invalid.",
                "api_key_tip": "Tip: Paste your API key from clipboard",
                "paste_api_key": "Paste API Key",
                "paste_api_key_message": "Paste your API key from clipboard?",
                "paste": "Paste",
                "cancel": "Cancel"
            ],
            .vietnamese: [
                // Navigation and Menu
                "jarvis_chatbot": "Jarvis Chatbot",
                "new_conversation": "Cuộc hội thoại mới",
                "search": "Tìm kiếm",
                "chat_history": "Lịch sử chat",
                "guide": "Hướng dẫn",
                "settings": "Cài đặt",
                "close": "Đóng",
                
                // Input fields
                "enter_message": "Nhập tin nhắn...",
                
                // Chat history
                "no_conversations": "Không có cuộc hội thoại nào",
                "messages": "tin nhắn",
                
                // Media selection
                "select_image": "Chọn ảnh",
                "take_photo": "Chụp ảnh",
                "select_file": "Chọn tệp",
                
                // Alerts
                "camera_not_available": "Không có Camera",
                "camera_error_message": "Thiết bị này không có camera hoặc quyền truy cập camera bị hạn chế.",
                "no_api_key_error": "Chưa có khóa API. Vui lòng thêm khóa API của bạn trong phần cài đặt.",
                
                // Settings
                "api_settings": "Cài đặt API",
                "api_configuration": "Cấu hình API",
                "api_provider": "Nhà cung cấp API",
                "api_key": "Khóa API",
                "request_limit": "Giới hạn yêu cầu (mỗi phút)",
                "save_settings": "Lưu cài đặt",
                "api_key_valid": "Khóa API hợp lệ.",
                "api_key_invalid": "Khóa API quá ngắn hoặc không hợp lệ.",
                "api_key_tip": "Mẹo: Dán khóa API từ bộ nhớ tạm",
                "paste_api_key": "Dán khóa API",
                "paste_api_key_message": "Dán khóa API từ bộ nhớ tạm?",
                "paste": "Dán",
                "cancel": "Hủy"
            ]
        ]
        
        return localizedStrings[language]?[self] ?? self
    }
}

// SwiftUI Text extension for easy localization
extension Text {
    static func localized(_ key: String, language: AppLanguage) -> Text {
        Text(key.localized(language))
    }
}

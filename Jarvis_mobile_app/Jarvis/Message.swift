//
// Message.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import Foundation
import UIKit // For UIImage

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date = Date()
    let imageData: Data? // Optional image data
    let fileName: String? // Optional file name
    
    init(text: String, isUser: Bool, imageData: Data? = nil, fileName: String? = nil) {
        self.text = text
        self.isUser = isUser
        self.imageData = imageData
        self.fileName = fileName
    }
}

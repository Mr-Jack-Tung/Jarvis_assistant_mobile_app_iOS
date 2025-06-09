//
//  ChatBubble.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//
import SwiftUI
import UIKit
import Foundation

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if !message.isUser {
                Image("ChatbotAvatar") // Use the asset image
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .padding(.trailing, 8)
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if let imageData = message.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200, maxHeight: 200)
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                }
                
                if let fileName = message.fileName {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.blue)
                        Text(fileName)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .padding(.bottom, 5)
                    .onTapGesture {
                        // In a real app, you would implement file opening logic here
                        print("Tapped on file: \(fileName)")
                    }
                }
                
                Text(message.text)
                    .padding()
                    .foregroundColor(message.isUser ? .white : .primary)
                    .background(
                        Group {
                            if message.isUser {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            } else {
                                Color(.systemGray6)
                            }
                        }
                    )
                    .cornerRadius(20, corners: message.isUser ? [.topRight, .bottomLeft] : [.topLeft, .bottomRight])
                    .cornerRadius(10, corners: message.isUser ? [.topLeft] : [.topRight])
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Text(timeString(from: message.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isUser ? .trailing : .leading)
            .transition(.opacity)
            .contextMenu {
                Button("Sao chép") {
                    UIPasteboard.general.string = message.text
                }
            }
            
            if message.isUser {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title)
                    .foregroundColor(.purple)
                    .padding(.leading, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
        .padding(.horizontal)
        .padding(.vertical, 6)
        .id(message.id)
        .onHover { hovering in
            #if targetEnvironment(macCatalyst) || os(macOS)
            if hovering {
                NSCursor.pointingHand.set()
            } else {
                NSCursor.arrow.set()
            }
            #endif
        }
        .hoverEffect(.highlight)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

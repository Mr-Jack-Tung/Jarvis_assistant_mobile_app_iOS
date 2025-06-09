//
// TypingIndicator.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import SwiftUI

struct TypingIndicator: View {
    @State private var dotScale: [CGFloat] = [0.5, 0.5, 0.5]
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .scaleEffect(dotScale[index])
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: dotScale[index]
                    )
            }
        }
        .foregroundColor(.gray)
        .onAppear {
            // Initialize with safe values
            dotScale = [1.0, 1.0, 1.0]
        }
    }
}

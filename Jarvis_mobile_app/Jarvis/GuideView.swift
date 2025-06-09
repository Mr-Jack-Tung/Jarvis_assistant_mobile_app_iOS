//
//  GuidView.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//
import SwiftUI
import UIKit
import Foundation

struct GuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Hướng dẫn sử dụng")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Nhập tin nhắn")
                        .font(.headline)
                    Text("Gõ tin nhắn của bạn vào ô nhập liệu ở cuối màn hình và nhấn nút gửi hoặc Enter để gửi đi.")
                    
                    Text("2. Sao chép tin nhắn")
                        .font(.headline)
                    Text("Chuột phải vào bất kỳ bong bóng tin nhắn nào và chọn 'Sao chép' để sao chép nội dung tin nhắn.")
                    
                    Text("3. Tạo cuộc trò chuyện mới")
                        .font(.headline)
                    Text("Nhấn vào menu 'Cuộc hội thoại mới' để bắt đầu một cuộc trò chuyện mới.")
                    
                    Text("4. Cài đặt")
                        .font(.headline)
                    Text("Nhấn vào menu 'Cài đặt' để cấu hình các tùy chọn ứng dụng.")
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

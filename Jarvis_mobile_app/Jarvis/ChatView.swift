//
//  ChatView.swift
//  Jarvis
//
//  Created by Mr.Jack on 08/06/2025.
//

import SwiftUI
import UIKit
import GoogleGenerativeAI // Added for Gemini integration
import Foundation // Ensure Foundation is imported for Date and UUID
import Combine // Added for Combine framework if needed for API calls
import PhotosUI // Added for image picking
import UniformTypeIdentifiers // Added for file types

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @State private var showGuide = false
    @State private var showSettings = false
    @State private var showChatHistory = false // New state for chat history
    @State private var showImagePicker = false
    @State private var showFilePicker = false
    @State private var showCameraPicker = false // New state for camera
    @State private var showAlert = false // New state for showing alert
    @State private var selectedImage: UIImage?
    @State private var selectedFile: URL?
    @State private var currentLanguage: AppLanguage = .english // Using AppLanguage enum instead of boolean
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.messages) { message in
                                ChatBubble(message: message)
                            }
                            if viewModel.isTyping {
                                HStack {
                                    Image("ChatbotAvatar") // Use the asset image
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .padding(.trailing, 8)
                                    TypingIndicator()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                            }
                        }
                        .padding(.top)
                    }
                    .onChange(of: viewModel.messages.count) {
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                /*
                 Các style phù hợp với Dynamic Type (tự động co giãn theo cài đặt accessibility của người dùng):
                 | Kiểu                           | Ý nghĩa                                    |
                 | ------------------------------ | ------------------------------------------ |
                 | `.largeTitle`                  | Dùng cho tiêu đề lớn, ví dụ màn hình chính |
                 | `.title`, `.title2`, `.title3` | Các cấp tiêu đề phụ                        |
                 | `.headline` / `.subheadline`   | Văn bản nổi bật hoặc giải thích thêm       |
                 | `.body`                        | Văn bản chính                              |
                 | `.callout`                     | Chú thích đặc biệt                         |
                 | `.footnote`                    | Ghi chú nhỏ                                |
                 | `.caption`, `.caption2`        | Chữ rất nhỏ (dưới ảnh, biểu đồ,...)        |
                 */
                HStack {
                    // Adjusting the width of the context menu by wrapping content in a VStack and applying a frame.
                    Menu {
                        VStack {
                            Button(action: {
                                showImagePicker = true
                            }) {
                                Label("select_image".localized(currentLanguage), systemImage: "photo.on.rectangle.angled")
                            }
                            Button(action: {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    showCameraPicker = true
                                } else {
                                    showAlert = true
                                }
                            }) {
                                Label("take_photo".localized(currentLanguage), systemImage: "camera.fill")
                            }
                            Button(action: {showFilePicker = true}) {
                                Label("select_file".localized(currentLanguage), systemImage: "doc.fill")
                            }
                        }
//                        .fixedSize(horizontal: true, vertical: false) // Force VStack to respect its content's ideal width
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(selectedImageItem: $viewModel.selectedImageItem)
                    }
                    .onChange(of: viewModel.selectedImageItem) { _, newItem in
                        Task {
                            if let newItem = newItem {
                                if newItem.canLoadObject(ofClass: UIImage.self) {
                                    do {
                                        let image = try await newItem.loadItem(forTypeIdentifier: UTType.image.identifier)
                                        if let image = image as? UIImage {
                                            await MainActor.run {
                                                selectedImage = image
                                                viewModel.handleImageSelection(image)
                                            }
                                        }
                                    } catch {
                                        print("Error loading image: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showCameraPicker) {
                        CameraPickerView(selectedImage: $selectedImage)
                            .onDisappear {
                                if let image = selectedImage {
                                    viewModel.handleImageSelection(image)
                                    selectedImage = nil // Reset after handling
                                }
                            }
                    }
                    .alert("camera_not_available".localized(currentLanguage), isPresented: $showAlert) {
                        Button("OK") { }
                    } message: {
                        Text("camera_error_message".localized(currentLanguage))
                    }
                    .sheet(isPresented: $showFilePicker) {
                        DocumentPicker(selectedFile: $selectedFile)
                            .onDisappear {
                                if let fileURL = selectedFile {
                                    viewModel.handleFileSelection(fileURL)
                                    selectedFile = nil // Reset after handling
                                }
                            }
                    }
                    
                    TextField("enter_message".localized(currentLanguage), text: $viewModel.inputText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .frame(height: 40)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.leading)
                    
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
            }
            .navigationTitle("jarvis_chatbot".localized(currentLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {viewModel.messages.removeAll()}) {
                            Label("new_conversation".localized(currentLanguage), systemImage: "plus.message.fill")
                        }
                        Button(action: {showGuide = true}) {
                            Label("search".localized(currentLanguage), systemImage: "magnifyingglass")
                        }
                        Button(action: {showChatHistory = true}) {
                            Label("chat_history".localized(currentLanguage), systemImage: "clock.fill")
                        }
                        Button(action: {showGuide = true}) {
                            Label("guide".localized(currentLanguage), systemImage: "book.closed.fill")
                        }
                        Button(action: {showSettings = true}) {
                            Label("settings".localized(currentLanguage), systemImage: "gearshape.fill")
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
                
                /*
                 Các placement thông dụng trong iOS/macOS:
                 | `ToolbarItemPlacement`     | Mô tả                                                              |
                 | -------------------------- | ------------------------------------------------------------------ |
                 | `.navigationBarLeading`    | Góc **trái** của thanh điều hướng (`NavigationBar`)                |
                 | `.navigationBarTrailing`   | Góc **phải** của thanh điều hướng                                  |
                 | `.navigationBarBackButton` | Thay thế nút **quay lại** mặc định (cẩn trọng khi dùng)            |
                 | `.bottomBar`               | Ở thanh công cụ phía **dưới cùng**                                 |
                 | `.keyboard`                | Trên thanh công cụ xuất hiện phía trên bàn phím (iOS)              |
                 | `.confirmationAction`      | Dùng cho nút **"OK", "Done"** trong modal/dialog                   |
                 | `.cancellationAction`      | Dùng cho nút **"Cancel"** trong modal/dialog                       |
                 | `.status`                  | Vị trí dành cho **trạng thái hệ thống** (macOS)                    |
                 | `.principal`               | Vị trí **trung tâm** trong `NavigationBar` (thường là tiêu đề lớn) |
                 */
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Button(action: {
                            // Toggle language
                            currentLanguage = currentLanguage == .english ? .vietnamese : .english
                            // Update the language in the ViewModel
                            viewModel.currentLanguage = currentLanguage
                        }) {
                            HStack(spacing: 4) {
                                // Display flag based on current language
                                Text(currentLanguage.flagEmoji)
                                    .font(.system(size: 26))
                            }
//                            .padding(8)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
                        }
                        Button(action: {
                            // Toggle account
                        }) {
                            HStack(spacing: 4) {
                                // Display flag based on current language
//                                Text("Account")
//                                    .font(.system(size: 14))
                                Image(systemName: "gearshape.fill")
//                                    .font(.system(size: 10))
                                    .foregroundColor(.blue)
                            }
//                            .padding(8)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
                        }
                    }
                }
            }
            .sheet(isPresented: $showGuide) {
                GuideView()
                    .environment(\.appLanguage, $currentLanguage)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environment(\.appLanguage, $currentLanguage)
            }
            .sheet(isPresented: $showChatHistory) {
                ChatHistoryView(sessions: viewModel.chatSessions)
                    .environment(\.appLanguage, $currentLanguage)
            }
            .onTapGesture {
                self.dismissKeyboard()
            }
            .onAppear {
                // Set the initial language in the ViewModel
                viewModel.currentLanguage = currentLanguage
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}


/*
 Trong SwiftUI, có rất nhiều loại **container view** và **layout view**. Dưới đây là các nhóm view phổ biến:

 ---

 ### 🧭 1. **Container & Layout Views**

 Dùng để bố trí, sắp xếp các view con:

 | View                             | Mô tả                                          |
 | -------------------------------- | ---------------------------------------------- |
 | `VStack`                         | Xếp các view theo **chiều dọc**                |
 | `HStack`                         | Xếp các view theo **chiều ngang**              |
 | `ZStack`                         | Xếp các view **chồng lên nhau**                |
 | `LazyVStack`                     | Phiên bản `VStack` hiệu quả hơn cho nhiều view |
 | `LazyHStack`                     | Tương tự `HStack` nhưng lazy                   |
 | `Grid`, `LazyVGrid`, `LazyHGrid` | Xếp view dạng **bảng**, lưới                   |
 | `Group`                          | Gom các view lại (không ảnh hưởng layout)      |

 ---

 ### 📱 2. **Navigation & Presentation Views**

 | View                | Mô tả                                            |
 | ------------------- | ------------------------------------------------ |
 | `NavigationView`    | Điều hướng giữa các màn hình (iOS 13–16)         |
 | `NavigationStack`   | Cấu trúc mới thay thế `NavigationView` từ iOS 16 |
 | `NavigationLink`    | Điều hướng sang một view khác                    |
 | `TabView`           | Tạo **thanh tab** dưới cùng                      |
 | `Sheet`, `.sheet()` | Trình bày view dạng **popup từ dưới lên**        |
 | `FullScreenCover`   | Trình bày view **toàn màn hình**                 |
 | `Popover`           | Popup nhẹ (iPad, Mac)                            |

 ---

 ### 🧩 3. **Form & Control Containers**

 | View              | Mô tả                        |
 | ----------------- | ---------------------------- |
 | `Form`            | Layout form theo kiểu iOS    |
 | `Section`         | Chia nhóm trong `Form`       |
 | `List`            | Danh sách cuộn (giống table) |
 | `ScrollView`      | Cho phép cuộn nội dung       |
 | `DisclosureGroup` | Mở rộng/thu gọn nội dung     |

 ---

 ### 🎨 4. **View hiển thị nội dung (UI Content)**

 | View                       | Mô tả             |
 | -------------------------- | ----------------- |
 | `Text`                     | Hiển thị văn bản  |
 | `Image`                    | Hiển thị hình ảnh |
 | `Button`                   | Nút bấm           |
 | `Toggle`                   | Bật/tắt           |
 | `Slider`, `Stepper`        | Giá trị số        |
 | `ProgressView`             | Thanh tiến trình  |
 | `TextField`, `SecureField` | Nhập văn bản      |
 | `DatePicker`, `Picker`     | Chọn giá trị      |

 ---

 ### 🎛 5. **Special Views & Modifiers**

 | View / Modifier   | Mô tả                  |
 | ----------------- | ---------------------- |
 | `Spacer()`        | Tạo khoảng trống       |
 | `Divider()`       | Tạo đường kẻ ngang/dọc |
 | `.background()`   | Gán nền                |
 | `.overlay()`      | Gán lớp phủ            |
 | `.cornerRadius()` | Bo góc                 |
 | `.shadow()`       | Đổ bóng                |

 ---

 ### 🧠 Gợi ý:

 Nếu bạn đang dùng iOS 16 trở lên, hãy **ưu tiên dùng `NavigationStack` thay vì `NavigationView`**, vì nó hiện đại hơn và dễ kiểm soát hơn.

 */

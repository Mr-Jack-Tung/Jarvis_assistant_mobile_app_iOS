# Jarvis Assistant Mobile App iOS

## Giới thiệu
Jarvis Chatbot Assistant là một ứng dụng di động đa năng được phát triển bằng SwiftUI, cho phép người dùng tương tác với nhiều mô hình AI khác nhau, bao gồm Gemini và OpenAI. Ứng dụng được thiết kế để cung cấp trải nghiệm trò chuyện mượt mà và trực quan, giúp người dùng dễ dàng truy cập các khả năng của AI ngay trên thiết bị di động của mình.

## Tính năng chính
-   **Hỗ trợ đa AI:** Tích hợp với Google Gemini và OpenAI API.
-   **Giao diện người dùng trực quan:** Thiết kế sạch sẽ và dễ sử dụng, tập trung vào trải nghiệm trò chuyện.
-   **Quản lý lịch sử trò chuyện:** Lưu trữ và xem lại các cuộc hội thoại trước đó.
-   **Cài đặt linh hoạt:** Cho phép người dùng cấu hình khóa API và chọn nhà cung cấp AI.
-   **Hỗ trợ đa ngôn ngữ:** Ứng dụng có khả năng hỗ trợ nhiều ngôn ngữ (hiện tại là tiếng Anh và tiếng Việt).
<br>

<p align="center">
  <img src="https://github.com/Mr-Jack-Tung/Jarvis_assistant_mobile_app_iOS/blob/main/Screenshoot/v0_1_03/IMG_02.jpg" width="45%" />
  <img src="link_anh_2" width="45%" />
</p>

![alt text]()

## Cài đặt
Để chạy ứng dụng Jarvis Chatbot trên mobile device hoặc simulator của bạn, hãy làm theo các bước sau:

### Yêu cầu
-   Xcode 15.0 trở lên
-   macOS Ventura (13.0) trở lên
-   iOS 16.0 trở lên
-   Kết nối internet (để tương tác với các API AI)

### Các bước cài đặt
1.  **Clone repository:**
    ```bash
    git clone [URL_REPOSITORY_CỦA_BẠN]
    cd Jarvis_assistant_mobile_app_iOS/Jarvis_mobile_app
    ```

2.  **Mở dự án trong Xcode:**
    Mở file `Jarvis.xcodeproj` bằng Xcode.

3.  **Cài đặt Dependencies:**
    Dự án sử dụng Swift Package Manager (SPM) để quản lý các thư viện bên ngoài. Xcode sẽ tự động tải xuống và cài đặt các dependencies khi bạn mở dự án. Đảm bảo rằng các gói sau đã được thêm:
    -   `GoogleGenerativeAI` (cho Gemini API) - https://github.com/google/generative-ai-swift
    -   `SwiftOpenAI` (cho OpenAI API) - https://github.com/jamesrochabrun/SwiftOpenAI

4.  **Cấu hình API Keys:**
    Ứng dụng yêu cầu khóa API cho Gemini và OpenAI. Bạn cần thêm khóa API của mình vào cài đặt ứng dụng sau khi chạy.
    -   Mở ứng dụng trên thiết bị hoặc trình giả lập.
    -   Đi tới màn hình "Cài đặt" (Settings).
    -   Nhập khóa API của bạn vào trường tương ứng.

## Sử dụng ứng dụng
1.  **Chạy ứng dụng:**
    -   Chọn thiết bị hoặc trình giả lập iOS trong Xcode.
    -   Nhấn nút "Run" (biểu tượng tam giác) hoặc `Cmd + R`.

2.  **Chọn nhà cung cấp AI:**
    -   Trong màn hình "Cài đặt", bạn có thể chọn giữa "Gemini" và "OpenAI" làm nhà cung cấp AI mặc định.

3.  **Bắt đầu trò chuyện:**
    -   Trên màn hình chính, nhập tin nhắn của bạn vào trường văn bản.
    -   Nhấn nút gửi để nhận phản hồi từ mô hình AI đã chọn.

4.  **Quản lý lịch sử:**
    -   Bạn có thể xem lại các cuộc hội thoại trước đó trong phần "Lịch sử chat".

## Cấu trúc dự án
-   `Jarvis/`: Chứa mã nguồn chính của ứng dụng SwiftUI.
    -   `APIProvider.swift`: Định nghĩa protocol cho các nhà cung cấp API và triển khai cho Gemini/OpenAI.
    -   `ChatViewModel.swift`: ViewModel xử lý logic trò chuyện và tương tác với API.
    -   `ChatView.swift`: Giao diện người dùng chính cho màn hình trò chuyện.
    -   `Message.swift`: Định nghĩa cấu trúc dữ liệu cho tin nhắn.
    -   `SettingsView.swift`: Giao diện người dùng cho cài đặt ứng dụng.
    -   `LanguageManager.swift`: Quản lý ngôn ngữ và nội địa hóa.
    -   ... và các file UI/utility khác.
-   `Assets.xcassets/`: Thư mục chứa tài nguyên đồ họa như biểu tượng, hình ảnh nền,...
-   `Info.plist`: Thông tin về ứng dụng.
-   `Jarvis.xcodeproj/`: File dự án Xcode.

## Đóng góp
Nếu bạn muốn đóng góp vào dự án, vui lòng fork repository và tạo một pull request nhé.

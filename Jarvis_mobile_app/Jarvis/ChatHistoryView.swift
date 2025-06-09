//
//  ChatHistoryView.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//

import SwiftUI

struct ChatHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.appLanguage) var appLanguage: Binding<AppLanguage>
    var sessions: [ChatSessionHistory] // Updated to use the correct type

    var body: some View {
        NavigationView {
            if sessions.isEmpty {
                VStack {
                    Text("no_conversations".localized(appLanguage.wrappedValue))
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    
                    Button("close".localized(appLanguage.wrappedValue)) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .navigationTitle("chat_history".localized(appLanguage.wrappedValue))
                .navigationBarTitleDisplayMode(.inline)
            } else {
                List {
                    ForEach(sessions) { session in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.name)
                                .font(.headline)
                            
                            HStack {
                                Text(formattedDate(session.date))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("\(session.messageCount) \("messages".localized(appLanguage.wrappedValue))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .navigationTitle("chat_history".localized(appLanguage.wrappedValue))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("close".localized(appLanguage.wrappedValue)) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ChatHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHistoryView(sessions: [
            ChatSessionHistory(name: "Hội thoại về AI", date: Date().addingTimeInterval(-86400), messageCount: 12),
            ChatSessionHistory(name: "Hỏi đáp về Swift", date: Date().addingTimeInterval(-172800), messageCount: 8),
            ChatSessionHistory(name: "Trợ giúp dự án", date: Date().addingTimeInterval(-259200), messageCount: 15),
            ChatSessionHistory(name: "Tìm hiểu SwiftUI", date: Date().addingTimeInterval(-345600), messageCount: 10)
        ])
    }
}

//
//  DocumentPicker.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//
import SwiftUI
import UIKit
import Foundation
import UniformTypeIdentifiers // Added for file types
import PhotosUI // Added for image picking

// MARK: - DocumentPicker UIViewControllerRepresentable
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFile: URL?
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFile = urls.first
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.selectedFile = nil
        }
    }
}

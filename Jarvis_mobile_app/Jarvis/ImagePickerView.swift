//
//  ImagePickerView.swift
//  Jarvis
//
//  Created by Mr.Jack on 09/06/2025.
//
import SwiftUI
import UIKit
import Foundation
import PhotosUI // Added for image picking

// MARK: - ImagePickerView UIViewControllerRepresentable
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImageItem: NSItemProvider?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1 // Allow only one image to be selected
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImageItem = results.first?.itemProvider
            parent.dismiss()
        }
    }
}

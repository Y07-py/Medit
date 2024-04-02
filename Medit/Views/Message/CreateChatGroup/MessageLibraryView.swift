//
//  MessageLibraryView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/27.
//

import SwiftUI
import PhotosUI

struct MessageLibraryView: View {
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            MessageLibraryController(selectedImage: $selectedImage)
        }
        .ignoresSafeArea()
    }
}

struct MessageLibraryController: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config: PHPickerConfiguration = PHPickerConfiguration()
        config.filter = .images
        let picker: PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        let parent: MessageLibraryController
        
        init(parent: MessageLibraryController) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                picker.dismiss(animated: true, completion: nil)
            }
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error: Error = error {
                        fatalError(error.localizedDescription)
                    }
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

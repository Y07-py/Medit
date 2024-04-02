//
//  EnterCameraPicker.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/16.
//

import Foundation
import Combine
import SwiftUI

struct EnterCameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    @EnvironmentObject var editorController: EditorControllerViewModel
    
    let isrouteView: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = .camera
        if isrouteView {
            imagePicker.allowsEditing = true
        } else {
            imagePicker.allowsEditing = false
        }
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var parent: EnterCameraPicker
        
        init(parent: EnterCameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
            self.parent.selectedImage = selectedImage
            if parent.isrouteView {
                self.parent.routeView.pop(1)
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            if parent.isrouteView {
                parent.routeView.pop(1)
            } else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}


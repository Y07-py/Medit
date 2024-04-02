//
//  CameraPicker.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/17.
//

import Foundation
import Combine
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
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
        
        var parent: CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.editedImage] as? UIImage else { return }
            self.parent.selectedImage = selectedImage
            if parent.isrouteView {
                let item: EditorDataBaseModel = .init(mediaData: .init(image: selectedImage))
                let lineId: String? = self.parent.editorController.selectedlineId
                if let index: Int = self.parent.editorController.lineList.firstIndex(where: {$0.id.uuidString == lineId }) {
                    self.parent.editorController.lineList.insert(item, at: index+1)
                } else {
                    self.parent.editorController.lineList.append(item)
                }
                
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

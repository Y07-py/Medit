//
//  EnterPhotoPicker.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/16.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI

struct EnterPhotoPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    
    let config: PHPickerConfiguration
    let isrouteView: Bool
    
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, selectedImage: $selectedImage)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller: PHPickerViewController = PHPickerViewController(configuration: config)
        controller.navigationController?.setToolbarHidden(true, animated: false)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: EnterPhotoPicker
        let selectedImage: Binding<UIImage?>
        
        init(parent: EnterPhotoPicker, selectedImage: Binding<UIImage?>) {
            self.parent = parent
            self.selectedImage = selectedImage
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                if parent.isrouteView {
                    parent.routeView.pop(1)
                    return
                } else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                for image in results {
                    if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                        image.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                self.selectedImage.wrappedValue = newImage as? UIImage
                            }
                        }
                    }
                }
            }
        }
    }
}


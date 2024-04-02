//
//  EnterImageEditorView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/16.
//


import SwiftUI
import Mantis

struct EnterImageEditorView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    @Binding var theImage: UIImage?
    @Binding var isShowing: Bool
    
    @State private var croppedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, theImage: $theImage, croppedImage: $croppedImage, isShown: $isShowing)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EnterImageEditorView>) -> Mantis.CropViewController {
        let Editor = Mantis.cropViewController(image: theImage ?? .init())
        Editor.delegate = context.coordinator
        return Editor
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: EnterImageEditorView
        
        @Binding var theImage: UIImage?
        @Binding var croppedImage: UIImage?
        @Binding var isShown: Bool
        
        init(parent: EnterImageEditorView, theImage: Binding<UIImage?>, croppedImage: Binding<UIImage?>, isShown: Binding<Bool>) {
            self.parent = parent
            self._theImage = theImage
            self._isShown = isShown
            self._croppedImage = croppedImage
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            self.croppedImage = cropped
            self.theImage = cropped
            parent.routeView.pop(2)
        }
        
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            parent.routeView.pop(1)
        }
    }
}


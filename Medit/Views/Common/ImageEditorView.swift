//
//  ImageEditorView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/15.
//

import SwiftUI
import Mantis

struct ImageEditorView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    @EnvironmentObject var editorController: EditorControllerViewModel
    @Binding var theImage: UIImage?
    @Binding var isShowing: Bool
    
    @State var croppedImage: UIImage? = nil
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, theImage: $theImage, croppedImage: $croppedImage, isShown: $isShowing)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditorView>) -> Mantis.CropViewController {
        let Editor = Mantis.cropViewController(image: theImage ?? .init())
        Editor.delegate = context.coordinator
        return Editor
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: ImageEditorView
        
        @Binding var theImage: UIImage?
        @Binding var croppedImage: UIImage?
        @Binding var isShown: Bool
        
        init(parent: ImageEditorView, theImage: Binding<UIImage?>, croppedImage: Binding<UIImage?>, isShown: Binding<Bool>) {
            self.parent = parent
            self._theImage = theImage
            self._isShown = isShown
            self._croppedImage = croppedImage
        }
        
        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            self.croppedImage = cropped
            let itemData: EditorDataBaseModel = .init(mediaData: .init(image: cropped))
            let lineid: String? = self.parent.editorController.selectedlineId
            if let index: Int = self.parent.editorController.lineList.firstIndex(where: { $0.id.uuidString == lineid }) {
                self.parent.editorController.lineList.insert(itemData, at: index+1)
            } else {
                self.parent.editorController.lineList.append(itemData)
            }
            parent.routeView.pop(2)
        }
        
        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            parent.routeView.pop(1)
        }
    }
}

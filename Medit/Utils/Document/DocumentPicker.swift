//
//  DocumentPicker.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/17.
//

import Foundation
import SwiftUI
import Combine

struct DocumentPicker: UIViewControllerRepresentable {
    @EnvironmentObject var reportView: projectReportViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @Binding var selectedImage: UIImage?
    
    let lcd: LocalDocumentHandler = LocalDocumentHandler()
    let isrouteView: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .jpeg, .png, .image])
        controller.allowsMultipleSelection = false
        controller.shouldShowFileExtensions = true
        controller.modalPresentationStyle = .formSheet
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            DispatchQueue.global(qos: .userInteractive).async { [self] in
                if let url: URL = urls.first {
                    // 取得したurlをローカルドキュメントに追加する
                    
                    self.parent.reportView.addURLs(pickedURL: url)
                    guard let localurl: URL = self.parent.reportView.selectedUrl else { return }
                    if let data: Data = try? Data(contentsOf: localurl ) {
                        self.parent.selectedImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.parent.lcd.removeUsingUrl(localURL: localurl)
                            self.parent.lcd.removeProjectDirectory(project: "project")
                        }
                    }
                }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            if self.parent.isrouteView {
                self.parent.routeView.pop(1)
            } else {
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
}




//
//  PopoverViewModifier.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/16.
//

import Foundation
import SwiftUI

struct PopoverViewModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    @Binding var isPresented: Bool
    @Binding var positionX: CGFloat
    @Binding var positionY: CGFloat
    let onDismiss: (() -> Void)?
    let content: () -> PopoverContent
    
    func body(content: Content) -> some View {
        content
            .background {
                Popover(isPresented: $isPresented,
                        positionX: $positionX,
                        positionY: $positionY,
                        onDismiss: self.onDismiss,
                        content: self.content
                )
            }
    }
}

fileprivate struct Popover<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var positionX: CGFloat
    @Binding var positionY: CGFloat
    let onDismiss: (() -> Void)?
    @ViewBuilder let content: () -> Content
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, content: self.content())
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.host.rootView = self.content()
        if  self.isPresented, uiViewController.presentedViewController == nil {
            let host = context.coordinator.host
            host.preferredContentSize = host.sizeThatFits(in: CGSize(width: Int.max, height: Int.min))
            host.modalPresentationStyle = UIModalPresentationStyle.popover
            host.popoverPresentationController?.delegate = context.coordinator
            host.popoverPresentationController?.sourceView = uiViewController.view
            host.popoverPresentationController?.sourceRect = uiViewController.view.bounds
            uiViewController.present(host,animated: true, completion: nil)
            return
        }
        
        if !self.isPresented && uiViewController.presentedViewController != nil {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        let host: UIHostingController<Content>
        private let parent: Popover
        
        init(parent: Popover, content: Content) {
            self.parent = parent
            self.host = UIHostingController(rootView: content)
        }
        
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            self.parent.isPresented = false
            if let onDismiss = parent.onDismiss {
                onDismiss()
            }
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
    }
}

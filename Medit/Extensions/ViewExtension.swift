//
//  ViewExtension.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/16.
//

import Foundation
import SwiftUI

extension View {
    func customPopover<Content>(isPresented: Binding<Bool>, positionX: Binding<CGFloat>,positionY: Binding<CGFloat>, onDismiss: (() -> Void)? = nil, content: @escaping () -> Content) -> some View where Content: View {
        ModifiedContent(content: self, modifier: PopoverViewModifier(isPresented: isPresented,
                                                                     positionX: positionX,
                                                                     positionY: positionY,
                                                                     onDismiss: onDismiss,
                                                                     content: content))
    }
    
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
    
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    public func asUIImage() -> UIImage {
        // This function changes View to UIView, then call another function
            let controller: UIHostingController = UIHostingController(rootView: self)
            controller.view.backgroundColor = .clear
            controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(controller.view)
            
            let size: CGSize = controller.sizeThatFits(in: UIScreen.main.bounds.size)
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.sizeToFit()
            
            let image: UIImage = controller.view.asUIImage()
            controller.view.removeFromSuperview()
            return image
    }
}

//
//  UIViewExtension.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/06.
//

import Foundation
import UIKit

extension UIView {
    func constrainCenter(in view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func constrainSize(_ size: CGSize) {
        self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    func constrainEdges(in view: UIView) {
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func constrainBottom(in view: UIView) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return self.subviews.compactMap { $0 as? T }
    }
    
    func removeLabels(with text: String) {
        let views: [UILabel] = findViews(subclassOf: UILabel.self).filter { $0.text == text }
        views.forEach { $0.removeFromSuperview() }
    }
    
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

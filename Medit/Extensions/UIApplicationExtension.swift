//
//  UIApplicationExtention.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/13.
//

import Foundation
import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
        
    }
}

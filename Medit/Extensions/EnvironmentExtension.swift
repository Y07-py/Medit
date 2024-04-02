//
//  EnvironmentExtension.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/01.
//

import Foundation
import SwiftUI

struct PresentationModalKey: EnvironmentKey {
    static let defaultValue = Binding<Bool>.constant(false)
}

extension EnvironmentValues {
    var isPresentationModal: Binding<Bool> {
        get { self[PresentationModalKey.self] }
        set { self[PresentationModalKey.self] = newValue }
    }
}

//
//  EditorPopupViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/09.
//

import Foundation
import SwiftUI

class EditorPopupViewModel: ObservableObject {
    @Published var lineId: UUID = .init()
    @Published var textColor: Color = .black // default Color
    @Published var textColorTitle: String = "Black"
    @Published var textColorSelected: Bool = false
    @Published var textFontTitle: String = "MPLUSRounded1c-Light"
    @Published var textFontSelected: Bool = false
    @Published var cursorPositionX: CGFloat = 0
    @Published var cursorPositionY: CGFloat = 0
    @Published var tempCursorPosition: CGFloat = 0
    @Published var isPopupEditor: Bool = true
    @Published var isLineHeightChange: Bool = false
}

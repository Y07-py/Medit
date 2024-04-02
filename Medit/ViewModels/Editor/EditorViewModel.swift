//
//  EditorViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/28.
//

import Foundation
import SwiftUI
import Combine

class EditorViewModel: ObservableObject {
    
    @Published var lineId: UUID = .init()
    @Published var text: String = ""
    @Published var textColor: Color = .black // default Color
    @Published var textColorTitle: String = "Black"
    @Published var textColorSelected: Bool = false
    @Published var textFontTitle: String = "MPLUSRounded1c-Light"
    @Published var textFontSelected: Bool = false
    @Published var cursorPositionX: CGFloat = 0
    @Published var cursorPositionY: CGFloat = 0
    @Published var tempCursorPosition: CGFloat = 0
    @Published var rowEdgeInsets: EdgeInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    @Published var isIncreaseIndent: Bool = false
    @Published var isDecreaseIndent: Bool = false
    @Published var lineNumber: Int = 1
    @Published var textAlignment: textAlignment = .left
    
    // listpopup columns
    @Published var listtype: listType = .normal
    @Published var istaskChecked: Bool = false
    @Published var rowInsets: EdgeInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        $isIncreaseIndent
            .receive(on: RunLoop.main)
            .sink { value in
                if value {
                    self.rowEdgeInsets.leading += 15
                }
            }
            .store(in: &cancellable)
        
        $isDecreaseIndent
            .receive(on: RunLoop.main)
            .sink { value in
                if value {
                    self.rowEdgeInsets.leading -= 15
                }
            }
            .store(in: &cancellable)
    }
}

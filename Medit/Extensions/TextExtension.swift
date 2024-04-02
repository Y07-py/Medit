//
//  TextExtension.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/08.
//

import Foundation
import SwiftUI

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
            .font(.system(size: 16))
    }
}

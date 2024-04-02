//
//  DeskFolderView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/21.
//

import SwiftUI

struct DeskFolderView<Content>: View where Content: View {
    
    @ViewBuilder
    var content: () -> Content
    
    var body: some View {
        VStack {
            content()
                .zIndex(10)
                .padding(.top, 5)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}


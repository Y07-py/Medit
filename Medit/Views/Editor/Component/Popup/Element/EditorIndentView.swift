//
//  EditorIndentView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/12.
//

import Foundation
import SwiftUI

struct EditorIndentView: View {
    @EnvironmentObject var editorModel: EditorViewModel
    @Environment(\.dismiss) var dismiss
    
    enum indentType {
        case increase
        case decrease
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                backBtn
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.top, 10)
            VStack(alignment: .leading) {
                selectBtn("increase.indent", text: "インデントを増やす", type: .increase)
                selectBtn("decrease.indent", text: "インデントを減らす", type: .decrease)
            }
            .padding(.leading, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func selectBtn(_ systemName: String, text: String, type: indentType) -> some View {
        Button(action: {
            switch type {
            case .increase:
                withAnimation(.easeIn) {
                    editorModel.isIncreaseIndent = true
                }
            case .decrease:
                withAnimation(.easeIn) {
                    editorModel.isDecreaseIndent = true
                }
            }
            
        }) {
            HStack {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
                Text(text)
                    .font(.callout)
                    .foregroundStyle(.black)
            }
        }
    }
    
    @ViewBuilder
    var backBtn: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
        }
    }
}

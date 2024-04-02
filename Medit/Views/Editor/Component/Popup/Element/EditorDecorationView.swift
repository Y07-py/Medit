//
//  EditorDecorationView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/31.
//

import SwiftUI

struct EditorDecorationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var editorView: EditorViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                backBtn
                Spacer()
            }
            .frame(height: 30)
            .padding(.top, 10)
            .padding(.leading, 15)
            VStack(alignment: .leading, spacing: 10) {
                itemButton(systemName: "square.fill", title: "ブロック", listType: .block)
                itemButton(systemName: "lane", title: "フォーカス", listType: .line)
            }
            .padding([.leading])
            Spacer()
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
    
    @ViewBuilder
    func itemButton(systemName: String, title: String, listType: listType) -> some View {
        Button(action: {
            withAnimation {
                self.editorView.listtype = listType
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 5)
                Text(title)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    EditorDecorationView()
}

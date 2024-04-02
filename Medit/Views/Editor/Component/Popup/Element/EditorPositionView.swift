//
//  EditorPositionView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/31.
//

import SwiftUI

struct EditorPositionView: View {
    @EnvironmentObject var editorModel: EditorViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                backBtn
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.top, 10)
            
            VStack(alignment: .leading) {
                listPositionButton(systemName: "text.alignleft", title: "左揃え", alignment: .left)
                listPositionButton(systemName: "text.aligncenter", title: "中央揃え", alignment: .center)
                listPositionButton(systemName: "text.alignright", title: "右揃え", alignment: .right)
                
            }
            .padding(.leading, 15)
            .padding(.top, 15)
            Spacer()
        }
        .toolbar(.hidden)
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
    func listPositionButton(systemName system: String, title: String, alignment: textAlignment) -> some View {
        Button(action: {
            editorModel.textAlignment = alignment
        }) {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: system)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
                Text(title)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.black)
            }
        }
    }
}


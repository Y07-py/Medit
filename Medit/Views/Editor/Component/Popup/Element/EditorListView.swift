//
//  EditorListView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/12.
//

import SwiftUI

struct EditorListView: View {
    @EnvironmentObject var editorModel: EditorViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
                .frame(height: 40)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    listTypeView("checkmark.square", title: "やることリスト", listtype: .task)
                    listTypeView("list.dash", title: "箇条書きリスト", listtype: .bullet)
                    listTypeView("list.number", title: "番号付きリスト", listtype: .numbers)
                    listTypeView("note", title: "リストなし", listtype: .normal)
                }
            }
        }
        .toolbar(.hidden)
        .overlay {
            HStack {
                backBtn
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.leading, 15)
            .padding(.top, 10)
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
    func listTypeView(_ systemName: String, title: String, listtype: listType) -> some View {
        Button(action: {
            editorModel.listtype = listtype
        }) {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(5)
                    .padding(.leading, 20)
                Text(title)
                    .font(.system(size: 18, weight: .light))
                    .padding(5)
                Spacer()
            }
            .foregroundStyle(.black)
        }
        .buttonStyle(.plain)
    }
}

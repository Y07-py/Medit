//
//  EditorFormatView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/12.
//

import Foundation
import SwiftUI

struct EditorFormatView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                backBtn
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.top, 10)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    formatSubView("doc.on.clipboard", title: "Markdown")
                    formatSubView("doc.text", title: "標準テキスト")
                }
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden)
    }
    
    @ViewBuilder
    func formatSubView(_ systemName: String, title: String) -> some View {
        Button(action: {
            dismiss()
        }) {
            HStack(alignment: .center) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding()
                Text(title)
                    .font(.system(size: 18, weight: .light))
                Spacer()
            }
            .foregroundStyle(.black)
        }
        .buttonStyle(.plain)
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



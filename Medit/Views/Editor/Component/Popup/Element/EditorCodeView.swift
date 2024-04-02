//
//  EditorCodeView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/18.
//

import SwiftUI

struct EditorCodeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var popupHeight: CGFloat
    @Binding var popupWidth: CGFloat
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            HStack {
                backBtn
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(height: 40)
            .padding(.top, 30)
            .padding(.leading, 20)
            ScrollViewReader { reader in
                ScrollView(.vertical) {
                    VStack {
                        TextField("コードエディタ-", text: $text)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.leading, 20)

        }
    }
    
    @ViewBuilder
    var backBtn: some View {
        Button(action: {
            withAnimation {
                self.popupHeight = 180
                self.popupWidth = 270
            }
            dismiss()
        }) {
            Image(systemName: "delete.backward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
        }
    }
}


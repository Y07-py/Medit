//
//  EditorSeparatorView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/31.
//

import SwiftUI

struct EditorSeparatorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var editorController: EditorControllerViewModel
    let lineId: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                backBtn
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 15)
            .padding(.leading, 15)
            
            VStack(alignment: .leading) {
                itemButton(title: "区切り-厚い", separateheight: 4.0)
                itemButton(title: "区切り-レギュラー", separateheight: 3.0)
                itemButton(title: "区切り-薄い", separateheight: 2.0)
                itemButton(title: "区切り-極薄", separateheight: 1.0)
            }
            .padding()
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
                .foregroundStyle(.black.opacity(0.8))
        }
    }
    
    @ViewBuilder
    func itemButton(title: String, separateheight: CGFloat) -> some View {
        Button(action: {
            if let index: Int = self.editorController.lineList.firstIndex(where: {$0.id.uuidString == lineId ?? ""}) {
                self.editorController.lineList.insert(.init(listType: .separate, separateHeight: separateheight), at: index+1)
            } else {
                self.editorController.lineList.append(.init(listType: .separate, separateHeight: separateheight))
            }
            dismiss()
        }) {
            HStack {
                Capsule()
                    .frame(width: 15, height: separateheight)
                    .foregroundStyle(.black)
                Text(title)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.black)
            }
        }
    }
}


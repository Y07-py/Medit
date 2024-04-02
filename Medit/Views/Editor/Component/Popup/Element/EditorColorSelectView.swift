//
//  EditorColorSelectView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/12.
//

import Foundation
import SwiftUI

struct EditorColorSelectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var editorModel: EditorViewModel
    @State private var textColorTitle: String = "Black"
    @State private var textColorSelected: Bool = false
    @State private var textColor: Color = .black
    
    struct TextColorModel: Identifiable {
        var id: UUID = .init()
        var color: Color
        var caption: String
    }
    
    let colors: [TextColorModel] = [
        .init(color: .init(hex: "#000000"), caption: "Black"),
        .init(color: .init(hex: "#006AFF"), caption: "Blue"),
        .init(color: .init(hex: "#E50914"), caption: "Netflix Red"),
        .init(color: .init(hex: "#25D366"), caption: "Light Green"),
        .init(color: .init(hex: "#075E54"), caption: "Teal Green Dark"),
        .init(color: .init(hex: "#FF9900"), caption: "Amazon Orange"),
        .init(color: .init(hex: "#5B51D8"), caption: "Royal Blue"),
        .init(color: .init(hex: "#FCAF45"), caption: "Yellow"),
        .init(color: .init(hex: "#FF00BF"), caption: "Lyft Pink")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 40)
            ScrollView {
                VStack(alignment: .leading, spacing:0) {
                    ForEach(colors) { color in
                        Button(action: {
                            textColorTitle = color.caption
                            textColorSelected = true
                            textColor = color.color
                        }) {
                            HStack {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(color.color)
                                    .padding(.leading, 20)
                                    .padding(.vertical, 10)
                                Text(color.caption)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .overlay {
                                Rectangle()
                                    .stroke(textColorTitle == color.caption ? .gray.opacity(0.2) : .clear, lineWidth: 1)
                            }
                            .background {
                                Rectangle()
                                    .foregroundStyle(textColorTitle == color.caption ? .gray.opacity(0.2) : .clear)
                            }
                        }
                        .onChange(of: textColorTitle) {
                            editorModel.textColorTitle = self.textColorTitle
                            editorModel.textColor = textColor
                            editorModel.textColorSelected = self.textColorSelected
                        }
                    }
                }
            }
            .frame(width: 280)
            .contentMargins(.vertical, 0, for: .scrollContent)
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
}

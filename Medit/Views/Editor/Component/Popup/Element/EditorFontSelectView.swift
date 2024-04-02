//
//  EditorFontSelectView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/12.
//

import Foundation
import SwiftUI

struct EditorFontSelectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var editorModel: EditorViewModel
    @State private var textFontTitle: String = "MPLUSRounded1c-Light"
    @State private var textFontSelected: Bool = false
    @State private var textFontSearchText: String = ""
    
    struct FontModel: Identifiable {
        var id: UUID = .init()
        var fontType: FontType
    }
    
    enum FontType: String{
        case NotoSerifJP
        case MPLUSRounded1cLight
        case DelaGothicOneRegular
        case NotoSerifJPBold
        case SawarabiMinchoRegular
        case DotGothic16Regular
        case TrainOneRegular
        case ZenAntiqueRegular
        case RampartOneRegular
        case ChokokutaiRegular
    }
    
    let fontTypeList: [FontModel] = [
        .init(fontType: .NotoSerifJP),
        .init(fontType: .MPLUSRounded1cLight),
        .init(fontType: .DelaGothicOneRegular),
        .init(fontType: .NotoSerifJPBold),
        .init(fontType: .SawarabiMinchoRegular),
        .init(fontType: .DotGothic16Regular),
        .init(fontType: .TrainOneRegular),
        .init(fontType: .ZenAntiqueRegular),
        .init(fontType: .RampartOneRegular),
        .init(fontType: .ChokokutaiRegular)
    ]
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(fontTypeList) { type in
                        Button(action: {
                            textFontTitle = fontSwitcher(type.fontType)
                            textFontSelected = true
                        }) {
                            HStack(alignment: .center) {
                                Spacer()
                                fontText(type.fontType, text: "Aa", size: 25)
                                Spacer()
                                fontText(type.fontType, text: "フォント", size: 20)
                                Spacer()
                            }
                            .foregroundStyle(.black)
                            .frame(width: 280)
                            .overlay {
                                Rectangle()
                                    .stroke(textFontTitle == fontSwitcher(type.fontType) ? .gray.opacity(0.2) : .clear)
                            }
                            .background {
                                Rectangle()
                                    .foregroundStyle(textFontTitle == fontSwitcher(type.fontType) ? .gray.opacity(0.2) : .clear)
                            }
                        }
                        .onChange(of: textFontTitle) {
                            editorModel.textFontTitle = textFontTitle
                            editorModel.textFontSelected = textFontSelected
                        }
                    }
                }
            }
        }
        .toolbar(.hidden)
        .overlay {
            HStack {
                backBtn
                TextField("Search Font", text: $textFontSearchText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .overlay {
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.2))
                }
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.leading, 15)
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    func fontText(_ type: FontType, text: String, size: CGFloat) -> some View {
        Text(text)
            .font(.custom(fontSwitcher(type), size: size))
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
    
    func fontSwitcher(_ font: FontType) -> String {
        switch font {
        case .MPLUSRounded1cLight:
            return "MPLUSRounded1c-Light"
        case .DelaGothicOneRegular:
            return "DelaGothicOne-Regular"
        case .NotoSerifJPBold:
            return "NotoSerifJP-Bold"
        case .SawarabiMinchoRegular:
            return "SawarabiMincho-Regular"
        case .DotGothic16Regular:
            return "DotGothic16-Regular"
        case .TrainOneRegular:
            return "TrainOne-Regular"
        case .ZenAntiqueRegular:
            return "ZenAntique-Regular"
        case .RampartOneRegular:
            return "RampartOne-Regular"
        case .ChokokutaiRegular:
            return "Chokokutai-Regular"
        case .NotoSerifJP:
            return "NotoSerifJP-Regular"
        }
    }
}

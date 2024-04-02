//
//  EditorDateView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/12.
//

import Foundation
import SwiftUI

struct EditorDateView: View {
    @Environment(\.dismiss) var dimiss
    @State private var calendarDate: Date = .init()
    var body: some View {
        VStack {
            HStack {
                Spacer()
                backBtn
                Spacer()
                    .frame(width: 180)
                decisionBtn
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.top, 100)
            DatePicker("Calendar", selection: $calendarDate)
                .datePickerStyle(.wheel)
                .scaleEffect()
                .environment(\.locale, Locale(identifier: "ja_JP"))
        }
        .toolbar(.hidden)
    }
    
    @ViewBuilder
    var decisionBtn: some View {
        Button(action: {
            dimiss()
        }) {
            Text("決定")
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .bold))
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(.black)
                }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var backBtn: some View {
        Button(action: {
            dimiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
        }
    }
}

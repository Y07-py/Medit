//
//  ToDoHeaderButtonView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/25.
//

import SwiftUI

struct ToDoHeaderButtonView: View {
    let headerIndex: Int
    let buttonName: String
    let systemName: String
    var namespace: Namespace.ID
    @Binding var currentIndex: Int
    
    var body: some View {
        Button(action: {
            currentIndex = headerIndex
        }) {
            VStack {
                HStack {
                    Image(systemName: systemName)
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(buttonName)
                        .font(.callout)
                }
                .foregroundStyle(.black)
                if (currentIndex == headerIndex) {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 2)
                        .foregroundStyle(.black.opacity(0.5))
                        .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                } else {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.clear)
                }
            }
        }
        .buttonStyle(.plain)
    }
}


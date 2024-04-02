//
//  TaskHeaderStatusView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/26.
//

import SwiftUI

struct TaskHeaderStatusView: View {
    @Binding var currentStatusBar: Int
    @Namespace var namespace
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                StatusButtonView(currentStatusBar: $currentStatusBar, namespace: namespace.self, title: "今日の全て", systemName: "square.stack.3d.down.forward", colorCode: "#13005A", status: 0)
                    .padding(.leading, 5)
                StatusButtonView(currentStatusBar: $currentStatusBar, namespace: namespace.self, title: "待機中", systemName: "square.stack", colorCode: "#0096FF", status: 1)
                StatusButtonView(currentStatusBar: $currentStatusBar, namespace: namespace.self, title: "進行中", systemName: "play.square.stack", colorCode: "#5800FF", status: 2)
                StatusButtonView(currentStatusBar: $currentStatusBar, namespace: namespace.self, title: "完了済", systemName: "checkmark.rectangle.stack", colorCode: "#27E1C1", status: 3)
                    .padding(.trailing, 5)
            }
            .frame(height: 45)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
    }
}

fileprivate struct StatusButtonView: View {
    @Binding var currentStatusBar: Int
    let namespace: Namespace.ID
    
    let title: String
    let systemName: String
    let colorCode: String
    let status: Int
    
    var body: some View {
        Button(action: {
            self.currentStatusBar = status
        }) {
            VStack(spacing: 5) {
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color(hex: colorCode))
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.black.opacity(0.8))
                }
                .padding(10)
                .frame(height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if status == currentStatusBar {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 2)
                        .foregroundStyle(.black.opacity(0.5))
                        .matchedGeometryEffect(id: "namespace", in: namespace, properties: .frame)
                } else {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.clear)
                }
            }
            .animation(.spring(), value: self.currentStatusBar)
        }
    }
}

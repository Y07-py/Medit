//
//  ToDoHeaderView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/25.
//

import SwiftUI

struct ToDoHeaderView: View {
    @Binding var currentIndex: Int
    @Namespace var namespace
    var body: some View {
        HStack {
            ToDoHeaderButtonView(headerIndex: 0, buttonName: "タスク", systemName: "list.bullet", namespace: namespace, currentIndex: $currentIndex)
            ToDoHeaderButtonView(headerIndex: 1, buttonName: "カレンダー", systemName: "calendar", namespace: namespace, currentIndex: $currentIndex)
        }
        .frame(height: 50)
    }
}

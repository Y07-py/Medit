//
//  ToDoView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/25.
//

import SwiftUI

struct ToDoView: View {
    @State private var currentIndex: Int = 0
    var body: some View {
        VStack {
            ToDoHeaderView(currentIndex: $currentIndex)
            TabView(selection: $currentIndex) {
                TaskView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                CalendarView()
                    .tag(1)
                    .toolbar(.hidden,for: .tabBar)
            }
        }
    }
}

#Preview {
    ToDoView()
}

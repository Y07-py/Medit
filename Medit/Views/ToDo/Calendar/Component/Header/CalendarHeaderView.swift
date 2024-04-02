//
//  CalendarHeaderView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/08.
//

import SwiftUI

struct CalendarHeaderView: View {
    
    @Binding var currentMonth: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(currentMonth)
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .frame(width: UIWindow().bounds.width, height: 40)
    }
}


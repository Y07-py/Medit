//
//  SelectTalktoView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/26.
//

import SwiftUI

struct SelectTalktoView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .center) {
            searchHeader
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    @ViewBuilder
    var searchHeader: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.gray)
            TextField("ユーザー名で探す。", text: $searchText)
        }
        .padding(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        }
    }
}

#Preview {
    SelectTalktoView()
}

//
//  TaskHeaderSearchView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/26.
//

import SwiftUI

struct TaskHeaderSearchView: View {
    @Binding var searchtext: String
    @Binding var searchBarTapped: Bool
    
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray.opacity(0.5))
                    .padding(.leading, 10)
                
                Text("タスクを検索")
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.gray)
                Spacer()
            }
            .matchedGeometryEffect(id: "searchbar", in: namespace)
        }
        .frame(width: UIWindow().bounds.width - 100, height: 40)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary.opacity(0.8), lineWidth: 1)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .shadow(color: .black.opacity(0.08), radius: 5, x:5, y:5)
        .onTapGesture {
            withAnimation {
                searchBarTapped.toggle()
            }
        }
        .matchedGeometryEffect(id: "card", in: namespace)
    }
}

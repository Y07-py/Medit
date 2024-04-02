//
//  TaskExpandedSearchView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/28.
//

import SwiftUI

struct TaskExpandedSearchView: View {
    @Binding var searchText: String
    @Binding var searchBarTapped: Bool
    
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Color
                .clear
                .ignoresSafeArea()
            VStack(alignment: .center) {
                HStack {
                    Button(action: {
                        withAnimation {
                            searchBarTapped.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .matchedGeometryEffect(id: "back", in: namespace)
                VStack {
                    HStack(alignment: .center, spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.gray.opacity(0.5))
                            .padding(.leading, 10)
                        TextField("タスクを検索", text: $searchText)
                    }
                    .frame(width: UIWindow().bounds.width - 80, height: 40)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
                    .background(.white)
                    .padding(.top, 10)
                    Spacer()
                }
                .frame(width: UIWindow().bounds.width - 50, height: 500)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.08), lineWidth: 1)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .matchedGeometryEffect(id: "card", in: namespace)
                .shadow(radius: 2, x: 2, y: 2)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}


//
//  TaskHeaderView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/26.
//

import SwiftUI
import Combine

struct TaskHeaderView: View {
    @Binding var searchtext: String
    @Binding var currentStatusBar: Int
    @Binding var searchBarTapped: Bool
    
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 15) {
                HStack(alignment: .center, spacing: 0) {
                    TaskHeaderSearchView(searchtext: $searchtext, searchBarTapped: $searchBarTapped, namespace: namespace)
                    Button(action: {}) {
                        Image(systemName: "slider.vertical.3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .contentShape(Rectangle())
                            .foregroundStyle(.black.opacity(0.5))
                            .padding(10)
                            .background(.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black.opacity(0.5), lineWidth: 1)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 5)
                }
         
                
                TaskHeaderStatusView(currentStatusBar: $currentStatusBar)
                
                TaskHeaderAchiveIndicatorView()
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray.opacity(0.8))
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(height: 250)
        }
    }
}

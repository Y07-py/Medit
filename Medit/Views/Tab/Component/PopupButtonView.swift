//
//  PopupButtonView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/26.
//

import SwiftUI

struct PopupButtonView: View {
    let foregroundColor: Color
    let systemName: String
    let buttonName: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: systemName)
                .resizable()
                .frame(width: 25, height: 25)
                .padding(.horizontal, 20)
                .foregroundStyle(foregroundColor)

            VStack(alignment: .leading) {
                Text(buttonName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                Text(subtitle)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.gray)
      
            }
            Spacer()
        }
        .frame(width: UIWindow().bounds.width-30, height: 80)
        .background(foregroundColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(foregroundColor.opacity(0.8), lineWidth: 1)
        }
    }
}

#Preview {
    PopupButtonView(foregroundColor: .blue, systemName: "person", buttonName: "新しいドキュメント", subtitle: "新しいノートの作成")
}

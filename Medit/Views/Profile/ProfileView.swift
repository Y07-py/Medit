//
//  ProfileView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/03.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            settingHeader
            HStack(alignment: .top, spacing: 20) {
                currentUserIcon
                VStack(alignment: .leading, spacing: 20) {
                    userName
                    HStack(alignment: .center, spacing: 20) {
                        Text("コミュニティ")
                            .font(.subheadline)
                            .foregroundStyle(.gray.opacity(0.8))
                        Text("フレンズ")
                            .font(.subheadline)
                            .foregroundStyle(.gray.opacity(0.8))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.8))
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    var settingHeader: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.black)
            }
            
            Button(action: {}) {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.black)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var currentUserIcon: some View {
        if let uiimage: UIImage = self.firebaseAuthView.usericon {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 120))
        } else {
            Circle()
                .frame(width: 120, height: 120)
                .foregroundStyle(.gray)
        }
    }
    
    @ViewBuilder
    var userName: some View {
        Text(self.firebaseAuthView.username)
            .font(.title)
            .foregroundStyle(.black.opacity(0.8))
    }
}

#Preview {
    ProfileView()
}

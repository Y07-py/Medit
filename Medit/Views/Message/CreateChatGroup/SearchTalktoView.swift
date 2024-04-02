//
//  SearchTallktoView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/26.
//

import SwiftUI

struct SearchTalktoView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            searchHeader
            ScrollView(.vertical) {
                VStack {
                    ForEach(Array(firebaseAuthView.users), id: \.key) { key, user in
                        UserView(user: user)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .onAppear {
            Task {
                try? await self.firebaseAuthView.fetchUsersData()
            }
        }
    }
    
    @ViewBuilder
    var searchHeader: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.gray.opacity(0.8))
            TextField("ユーザー名で探す。", text: $searchText)
        }
        .padding(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        }
    }
}

fileprivate struct UserView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var isadded: Bool = false
    
    let user: FirebaseModel
    
    var body: some View {
        HStack(alignment: .center) {
            if let uiimage: UIImage = user.coverImage {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            } else {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray.opacity(0.5))
            }
            Text(user.username)
                .font(.headline)
                .foregroundStyle(.black.opacity(0.8))
            Spacer()
            Button(action: {
                withAnimation {
                    self.isadded.toggle()
                    self.firebaseAuthView.addedusers[user.id] = user
                }
            }) {
                ZStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black.opacity(0.8), lineWidth: 1)
                        }
                    if isadded {
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.blue.opacity(0.8))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            if self.firebaseAuthView.addedusers.contains(where: { $0.key == user.id }) {
                self.isadded = true
            }
        }
    }
}

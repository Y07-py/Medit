//
//  CreateChatGroupView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/26.
//

import Foundation
import SwiftUI

struct CreateChatGroupView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<MessageRoute>
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var iscoverImage: Bool = false
    @State private var issearchTalkto: Bool = false
    @State private var groupName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            header
            coverImage
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    chatGroupName
                    Spacer()
                }
                HStack {
                    addUser
                    Spacer()
                }
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(Array(self.firebaseAuthView.addedusers), id: \.key) { key, user in
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
                                    self.firebaseAuthView.addedusers.removeValue(forKey: key)
                                }) {
                                    Image(systemName: "person.fill.badge.minus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .toolbar(.hidden)
        .popover(isPresented: $iscoverImage) {
            MessageCoverImageView(coverImage: $selectedImage)
        }
        .popover(isPresented: $issearchTalkto) {
            SearchTalktoView()
        }
        .alert(isPresented: $isAlert) {
            var text: String = ""
            if self.firebaseAuthView.addedusers.isEmpty && self.groupName.isEmpty {
                text = "グループ名の記入およびユーザーを選択してください。"
            } else if self.firebaseAuthView.addedusers.isEmpty && !self.groupName.isEmpty {
                text = "ユーザーを選択してください。"
            } else if !self.firebaseAuthView.addedusers.isEmpty && self.groupName.isEmpty {
                text = "グループ名を記入してくさい。"
            }
            return Alert(title: Text(text), dismissButton: .default(Text("OK")))
        }
    }
    
    @ViewBuilder
    var header: some View {
        HStack(alignment: .center) {
            Button(action: {
                routeView.pop(1)
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: {
                if self.groupName.isEmpty || self.firebaseAuthView.addedusers.isEmpty {
                    self.isAlert.toggle()
                } else {
                    Task {
                        self.firebaseAuthView.groupName = self.groupName
                        self.firebaseAuthView.chatGroupCoverImage = self.selectedImage
                        try? await self.firebaseAuthView.createChatGroup()
                        self.routeView.pop(1)
                    }
                }
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.init(hex: "1A5D1A"))
            }
        }
    }
    
    @ViewBuilder
    var coverImage: some View {
        Button(action: {
            self.iscoverImage.toggle()
        }) {
            if let coverImage: UIImage = self.selectedImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 150))
            } else {
                Image(systemName: "photo.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.black.opacity(0.8))
            }
        }
    }
    
    @ViewBuilder
    var chatGroupName: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: "pencil")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .foregroundStyle(.black.opacity(0.8))
            TextField("グループ名", text: $groupName)
        }
    }
    
    @ViewBuilder
    var addUser: some View {
        Button(action: {
            self.issearchTalkto.toggle()
        }) {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.black.opacity(0.8))
                Text("ユーザーを追加")
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.8))
            }
        }
    }
}

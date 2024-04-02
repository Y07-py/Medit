//
//  DeskMenuView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/12.
//

import SwiftUI

struct DeskMenuView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    @Binding var folderStatus: FileStatus
    
    var body: some View {
        HStack {
            sideMenu
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    var sideMenu: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                userIcon
                username
                Rectangle()
                    .frame(width: UIWindow().bounds.width * (3/4), height: 1)
                    .foregroundStyle(.gray.opacity(0.3))
                    .padding(.trailing, 20)
            }
            .padding(.vertical)
            
            HStack(alignment: .center) {
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.blue.opacity(0.5))
                Text("フォルダ")
                    .foregroundStyle(.gray.opacity(0.8))
                    .font(.callout)
            }
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    sidemenuButton(systemName: "doc", title: "ドキュメント", folderStatus: .document)
                    sidemenuButton(systemName: "list.clipboard", title: "タスク", folderStatus: .task)
                    sidemenuButton(systemName: "pencil.line", title: "メモ", folderStatus: .memo)
                }
            }
            Spacer()
            signOutButton
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    @ViewBuilder
    func sidemenuButton(systemName: String, title: String, folderStatus: FileStatus) -> some View {
        Button(action: {
            withAnimation {
                self.folderStatus = folderStatus
            }
        }) {
            HStack(alignment: .center, spacing: 10) {
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundStyle(.black.opacity(0.5))
                HStack(alignment: .center) {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height:20)
                        .foregroundStyle(.gray.opacity(0.8))
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.gray.opacity(0.8))
                }
                .padding(10)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(self.folderStatus == folderStatus ? .blue.opacity(0.2) : .clear)
                )
            }
        }
    }
    
    @ViewBuilder
    var signOutButton: some View {
        Button(action: {
            self.firebaseAuthView.regularSignOut { error in
                if let error: Error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "arrow.backward.to.line")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.red)
                Text("サインアウト")
                    .font(.headline)
                    .foregroundStyle(.red.opacity(0.8))
            }
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    var userIcon: some View {
        if let uiImage: UIImage = self.firebaseAuthView.usericon {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 100))
        } else {
            Circle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray)
        }
    }
    
    @ViewBuilder
    var username: some View {
        Text(firebaseAuthView.username)
            .font(.headline)
    }
}


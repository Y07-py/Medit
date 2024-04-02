//
//  EnterSecondView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/12.
//

import SwiftUI

struct EnterSecondView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
   
    @State private var username: String = ""
    @State private var profile: String = ""
    @State private var isPopup: Bool = false
    @State private var isAllComp: Bool = false
    
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Spacer()
                    nextButton
                }
                userIcon
                enterTextField(title: "ユーザーネーム", text: $username)
                profileTextField
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .toolbar(.hidden)
            .popover(isPresented: $isPopup, content: {
                HStack {
                    userIconPopup
                    Spacer()
                }
                .presentationCompactAdaptation(.sheet)
                .presentationDetents([.height(300)])
            })
            
            if isAllComp {
                Color.gray
                    .opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    @ViewBuilder
    var nextButton: some View {
        Button(action: {
            self.firebaseAuthView.username = self.username
            self.firebaseAuthView.usericon = self.selectedImage
            self.firebaseAuthView.profile = self.profile
            Task {
                try? await self.firebaseAuthView.regularCreateAccount(email: firebaseAuthView.email, password: firebaseAuthView.password, username: username, profile: profile)
            }
            self.isAllComp = true
        }) {
            Image(systemName: "arrowshape.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:30, height: 30)
                .padding(.horizontal)
                .foregroundStyle(isallChecked() ? .blue : .gray)
        }
        .foregroundStyle(isallChecked() ? .gray : .primary)
        .disabled(!isallChecked())
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var userIcon: some View {
        Button(action: {
            self.isPopup.toggle()
        }) {
            if let uiimage: UIImage = self.selectedImage {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 150))
                    .overlay {
                        RoundedRectangle(cornerRadius: 150)
                            .stroke(.blue, lineWidth: 3)
                    }
            } else {
                Image("user")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(30)
                    .background {
                        RoundedRectangle(cornerRadius: 150)
                            .foregroundStyle(.blue.opacity(0.2))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 150)
                            .stroke(.blue, lineWidth: 3)
                    }
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var profileTextField: some View {
        VStack {
            TextField("プロファイル", text: $profile, axis: .vertical)
        }
        .padding()
    }
    
    @ViewBuilder
    var userIconPopup: some View {
        VStack(alignment: .leading, spacing: 30) {
            userIconPopupText(systemName: "photo", title: "ライブラリ", routeType: .ribraly, issystem: true)
            userIconPopupText(systemName: "camera", title: "カメラ", routeType: .camera, issystem: true)
            userIconPopupText(systemName: "unsplash", title: "Unsplash", routeType: .unsplash, issystem: false)
        }
        .padding()
    }
    
    @ViewBuilder
    func userIconPopupText(systemName: String, title: String, routeType: Enter, issystem: Bool) -> some View {
        Button(action: {
            self.routeView.push(routeType)
            self.isPopup.toggle()
        }) {
            HStack(alignment: .center) {
                if issystem {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black.opacity(0.8))
                } else {
                    Image(systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black.opacity(0.8))
                }
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.8))
            }
        }
    }
    
    @ViewBuilder
    func enterTextField(title: String, text: Binding<String>) -> some View {
        VStack {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                TextField(title, text: text)
                
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.8))
        }
        .padding()
    }
    
    func isallChecked() -> Bool {
        return !self.username.isEmpty
    }
}

//#Preview {
//    EnterSecondView()
//}
//

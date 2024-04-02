//
//  EnterView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/09.
//

import SwiftUI

struct EnterSignUpView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var checkPassword: String = ""
    @State private var isAlert: Bool = false
    @State private var iscircularloading: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 30) {
                enterTextView(title: "メールアドレス", text: $email)
                enterSecureTextView(title: "パスワード", text: $password)
                enterSecureTextView(title: "パスワード(確認用)", text: $checkPassword)
                loginButton
                alreadyHaveAccountButton
                googleLoginFormView
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .alert(isPresented: $isAlert) {
                Alert(title: Text("パスワードが異なっています。"),
                      dismissButton: .default(Text("OK")))
            }
            
            if iscircularloading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }
    
    @ViewBuilder
    func enterTextView(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "tray.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black.opacity(0.8))
                TextField("\(title)", text: text)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.8))
        }
        .padding()
    }
    
    @ViewBuilder
    func enterSecureTextView(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "lock.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black.opacity(0.8))
                SecureField("\(title)", text: text)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.8))
        }
        .padding()
    }
    
    @ViewBuilder
    var googleLoginFormView: some View {
        Button(action: {}) {
            HStack(alignment: .center) {
                Image("google")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text("Googleアカウントでログイン")
                    .font(.callout)
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray.opacity(0.8), lineWidth: 1)
            }
        }
    }
    
    @ViewBuilder
    var loginButton: some View {
        Button(action: {
            self.iscircularloading.toggle()
            if password == checkPassword {
                self.firebaseAuthView.email = self.email
                self.firebaseAuthView.password = self.password
                routeView.push(.profile)
            } else {
                self.isAlert.toggle()
            }
        }) {
            Text("サインアップ")
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(isAllChecked() ? Color.init(hex: "15F5BA") : .gray.opacity(0.8))
                }
        }
        .disabled(!isAllChecked())
    }
    
    @ViewBuilder
    var alreadyHaveAccountButton: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("すでにアカウントをお持ちの方:")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.8))
            Button(action: {
                routeView.push(.signin)
            }) {
                Text("サインイン")
                    .font(.subheadline)
                    .foregroundStyle(.blue.opacity(0.8))
            }
        }
    }
    
    func isAllChecked() -> Bool {
        return !self.email.isEmpty && !self.password.isEmpty && !self.checkPassword.isEmpty
    }
}

#Preview {
    EnterSignUpView()
}


//
//  EnterSignInView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/19.
//

import SwiftUI

struct EnterSignInView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var iscircularloading: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            enterTextView(title: "メールアドレス", text: $email)
            enterSecureTextView(title: "パスワード", text: $password)
            loginButton
        }
        .frame(maxHeight: .infinity, alignment: .top)
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
    var loginButton: some View {
        Button(action: {
            self.iscircularloading.toggle()
            self.firebaseAuthView.email = self.email
            self.firebaseAuthView.password = self.password
            Task {
                try await self.firebaseAuthView.regularSignIn()
            }
        }) {
            Text("サインイン")
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
    
    func isAllChecked() -> Bool {
        return !self.email.isEmpty && !self.password.isEmpty
    }
}

#Preview {
    EnterSignInView()
}

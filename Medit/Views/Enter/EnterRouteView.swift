//
//  EnterRouteView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/12.
//

import SwiftUI

enum Enter: Equatable {
    case signup
    case signin
    case profile
    case unsplash
    case ribraly
    case camera
    case photoEditor
}

struct EnterRouteView: View {
    @StateObject var routeView: NavigationRouterViewModel<Enter> = NavigationRouterViewModel(route: Enter.signup)
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowing: Bool = false
    
    var body: some View {
        RouterHostController(router: routeView) { phase in
            switch(phase) {
            case .signup: EnterSignUpView()
            case .signin: EnterSignInView()
            case .profile: EnterSecondView(selectedImage: $selectedImage)
            case .unsplash: EnterUnsplashView(selectedImage: $selectedImage, isrouteView: true)
            case .ribraly: EnterPhotoView(selectedImage: $selectedImage, isrouteView: true)
            case .camera: EnterCameraView(selectedImage: $selectedImage, isrouteView: true)
            case .photoEditor: EnterImageEditorView(theImage: $selectedImage, isShowing: $isShowing).ignoresSafeArea()
            }
        }
        .environmentObject(routeView)
        .environmentObject(firebaseAuthView)
        .ignoresSafeArea()
    }
}


//
//  MainRouteView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/12.
//

import SwiftUI


enum Route: Equatable {
    case Main
    case TaskEditor
    case DocumentEditor
    case MemoEditor
    case FileEditor
    case ChatRoom
}

struct MainRouteView: View {
    @StateObject var routeView: NavigationRouterViewModel = NavigationRouterViewModel(route: Route.Main)
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowing: Bool = false
    
    var body: some View {
        ZStack {
            RouterHostController(router: routeView) { route in
                switch route {
                case .Main: MainTabView()
                case .DocumentEditor: DocumentViewController().ignoresSafeArea()
                case .TaskEditor: TaskViewController().ignoresSafeArea()
                case .MemoEditor: MemoViewController().ignoresSafeArea()
                case .FileEditor: Text("File Editor")
                case .ChatRoom: ChatRoomView()
                }
            }
            .environmentObject(routeView)
            .environmentObject(editorMasterController)
            .environmentObject(firebaseAuthView)
            .ignoresSafeArea()
        }
    }
}

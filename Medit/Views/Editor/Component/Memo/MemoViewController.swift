//
//  MemoViewController.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/24.
//

import Foundation
import SwiftUI

struct MemoViewController: View {
    @StateObject var memoRouteView: NavigationRouterViewModel<MediaRoute> = NavigationRouterViewModel(route: MediaRoute.Main)
    @ObservedObject var editorController: EditorControllerViewModel = EditorControllerViewModel()
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowing: Bool = false
    
    
    var body: some View {
        ZStack {
            RouterHostController(router: memoRouteView) { route in
                switch route {
                case .Main: MemoEditorView().ignoresSafeArea()
                case .Camera: CameraView(selectedImage: $selectedImage, isrouteView: true)
                case .PhotoLibrary: PhotoView(selectedImage: $selectedImage, isrouteView: true)
                case .PhotoEditor: ImageEditorView(theImage: $selectedImage, isShowing: $isShowing).ignoresSafeArea()
                case .Canvas: DrawingView()
                case .Unsplash: UnsplashView(selectedImage: $selectedImage, isrouteView: true)
                case .GoogleDrive: Text("Google Drive View!")
                }
            }
            .environmentObject(editorController)
            .environmentObject(editorMasterController)
            .environmentObject(memoRouteView)
            .environmentObject(routeView)
        }
    }
}

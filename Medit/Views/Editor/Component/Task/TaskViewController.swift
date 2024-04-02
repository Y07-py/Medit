//
//  TaskViewController.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/24.
//

import Foundation
import SwiftUI

enum MediaRoute: Equatable {
    case Main
    case Camera
    case PhotoLibrary
    case PhotoEditor
    case Canvas
    case Unsplash
    case GoogleDrive
}

struct TaskViewController: View {
    @StateObject var taskRouteView: NavigationRouterViewModel = NavigationRouterViewModel(route: MediaRoute.Main)
    @ObservedObject var editorController: EditorControllerViewModel = EditorControllerViewModel()
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowing: Bool = false
    
    var body: some View {
        ZStack {
            RouterHostController(router: taskRouteView) { route in
                switch route {
                case .Main: TaskEditorView().ignoresSafeArea()
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
            .environmentObject(taskRouteView)
            .environmentObject(routeView)
        }
        .onAppear {
            Task {
                self.editorController.selectedTaskModel = self.editorMasterController.selectedTaskModel
                guard let newValue: EditorTaskModel = self.editorController.selectedTaskModel else { return }
                self.editorController.title = newValue.title ?? ""
                if let imageData: Data = newValue.coverImage {
                    if let image: UIImage = UIImage(data: imageData) {
                        self.editorController.coverImage = image
                    }
                }
            }
        }
    }
}

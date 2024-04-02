//
//  EnterCameraView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/16.
//

import SwiftUI
import Foundation

struct EnterCameraView: View {
    @Binding var selectedImage: UIImage?
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    
    let isrouteView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EnterCameraPicker(selectedImage: $selectedImage, isrouteView: isrouteView)
        }
        .ignoresSafeArea()
        .background(.white)
    }
}

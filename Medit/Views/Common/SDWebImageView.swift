//
//  SDWebImageView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/15.
//

import SwiftUI
import SDWebImageSwiftUI

struct SDWebImageView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    
    let url: String
    let isrouteView: Bool
    @State private var uiImage: UIImage? = nil
    @Binding var selectedImage: UIImage?
    @Binding var selectedURL: String
    
    var body: some View {
        WebImage(url: URL(string: url))
            .onSuccess(perform: { image, data, cacheType in
                self.uiImage = image.withRenderingMode(.automatic)
            })
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
                if isrouteView {
                    if self.uiImage == nil {
                        return
                    }
                    self.selectedImage = self.uiImage
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.routeView.push(.PhotoEditor)
                    }
                } else {
                    self.selectedImage = self.uiImage
                }
                self.selectedURL = url
            }
        
    }
}

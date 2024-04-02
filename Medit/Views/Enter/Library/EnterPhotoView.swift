//
//  EnterPhotoView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/16.
//

import Foundation
import SwiftUI
import PhotosUI

struct EnterPhotoView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Enter>
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isSelected: Bool = false
    @State private var croppedImage: UIImage?
    
    @Binding var selectedImage: UIImage?
    
    let isrouteView: Bool
    
    var pickerConfig: PHPickerConfiguration {
        var config: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary .shared())
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        return config
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EnterPhotoPicker(config: pickerConfig, isrouteView: isrouteView, selectedImage: $selectedImage)
                .toolbar(.hidden)
        }
        .ignoresSafeArea()
        .background(.white)
        .onChange(of: selectedImage) { oldValue, newValue in
            if isrouteView {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    routeView.push(.photoEditor)
                }
            } else {
                dismiss()
            }
        }
    }
}


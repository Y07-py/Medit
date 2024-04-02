//
//  TextKeyBoardView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/28.
//

import SwiftUI
import Photos
import PhotosUI
import Mantis

struct TextKeyBoardView: View {
    @EnvironmentObject var editorController: EditorControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    
    @Binding var isMediaSheetActive: Bool
    @Binding var isKeyBoardActive: Bool
    
    @State private var mediaSheetOffsetY: CGFloat = 550
    @State private var isPhotoLibraryActive: Bool = false
    
    var pickerConfig: PHPickerConfiguration {
        var config: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary .shared())
        config.filter = .images
        config.selectionLimit = 20
        config.preferredAssetRepresentationMode = .current
        return config
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        withAnimation(.easeOut) {
                            isMediaSheetActive = true
                            mediaSheetOffsetY = 340
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }) {
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.black.opacity(0.5))
                            .padding(.vertical, 15)
                            .padding(.leading, 15)
                            .padding(.trailing, 5)
                    }
                    .padding(.horizontal, 5)
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        isKeyBoardActive = true
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 40)
                            .foregroundStyle(.gray.opacity(0.1))
                            .overlay {
                                HStack {
                                    Text("Aa")
                                        .foregroundStyle(.gray)
                                        .padding(.leading, 15)
                                    Spacer()
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundStyle(.gray)
                                        .padding(.trailing, 15)
                                }
                            }
                    }
                    
                    Button(action: {}) {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.clear)
                            .frame(width: 40, height: 40)
                            .overlay {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.black.opacity(0.8))
                            }
                        
                    }
                    .padding(.trailing, 15)
                    .buttonStyle(.plain)
                }
                Spacer()
                    .frame(height: 30)
            }
            .background(.white)
            .overlay {
                Rectangle()
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
        .onChange(of: isMediaSheetActive) { oldValue, newValue in
            if (!newValue){
                withAnimation {
                    self.mediaSheetOffsetY = 550
                }
                
            }
        }
        
        mediaKeyBoardView(isPhotoLibraryActive: $isPhotoLibraryActive, isKeyboardActive: $isKeyBoardActive)
            .offset(y: mediaSheetOffsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.spring) {
                            if value.location.y > 340 {
                                self.mediaSheetOffsetY = value.location.y
                            }
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.spring) {
                            if value.location.y > 400 {
                                self.mediaSheetOffsetY = 550
                            } else {
                                self.mediaSheetOffsetY = 340
                            }
                        }
                    })
            )
            .environmentObject(editorController)
            .environmentObject(routeView)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
}

fileprivate struct mediaKeyBoardView: View {
    @EnvironmentObject var editorController: EditorControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    
    @Binding var isPhotoLibraryActive: Bool
    @Binding var isKeyboardActive: Bool
    
    @State private var isCameraActive: Bool = false
    @State private var isFolderActive: Bool = false
    @State private var isPhotoActive: Bool = false
    
    @State private var photoImages: [PhotosPickerItem] = []
    @State var num: Int = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Capsule(style: .continuous)
                .frame(width: 50, height: 2)
                .foregroundStyle(.gray)
                .offset(y: -30)
            
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    Button(action: {
                        routeView.push(.PhotoLibrary)
                    }) {
                        mediaButtonView("photo_icon", text: "ライブラリ")
                    }
                    mediaButtonView("Camera_Icon", text: "カメラ")
                    mediaButtonView("files_icon", text: "ファイル")
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
            }
        }
        .frame(width: UIWindow().bounds.width, height: 150)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.gray.opacity(0.5), lineWidth: 1)
        }
    }
    
    @ViewBuilder
    func mediaButtonView(_ image: String, text: String) -> some View {
        VStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.4), lineWidth: 0.5)
                }
            Text(text)
                .foregroundStyle(.black.opacity(0.5))
                .font(.caption)
        }
    }
}

struct PhotoView: View {
    @EnvironmentObject var editorController: EditorControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    
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
            PhotoPicker(config: pickerConfig, isrouteView: isrouteView, selectedImage: $selectedImage)
                .toolbar(.hidden)
        }
        .ignoresSafeArea()
        .background(.white)
        .onChange(of: selectedImage) { oldValue, newValue in
            if isrouteView {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    routeView.push(.PhotoEditor)
                }
            } else {
                dismiss()
            }
        }
    }
}


struct CameraView: View {
    @Binding var selectedImage: UIImage?
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    
    let isrouteView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CameraPicker(selectedImage: $selectedImage, isrouteView: isrouteView)
        }
        .ignoresSafeArea()
        .background(.white)
    }
}

struct DocumentPickerView: View {
    @Binding var selectedImage: UIImage?
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    @StateObject var reportView: projectReportViewModel = projectReportViewModel(project: nil)
    
    let isrouteView: Bool
    var body: some View {
        VStack {
            DocumentPicker(selectedImage: $selectedImage, isrouteView: isrouteView)
                .environmentObject(reportView)
        }
        .ignoresSafeArea()
        .background(.white)
    }
}



//
//  EditorMediaView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/31.
//

import SwiftUI

struct EditorMediaView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    @EnvironmentObject var editorController: EditorControllerViewModel
    
    enum MediaType {
        case PhotoLibrary
        case DrawPicture
        case Unsplash
        case Camera
        case GoogleDrive
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Spacer()
                .frame(height: 40)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    mediaListView("photo.on.rectangle", isSystemName: true, title: "フォトライブラリから選択", type: .PhotoLibrary)
                    mediaListView("applepencil.and.scribble", isSystemName: true, title: "手書きの図面を作成", type: .DrawPicture)
                    mediaListView("photo.badge.arrow.down", isSystemName: true, title: "Unsplashから選択", type: .Unsplash)
                    mediaListView("camera", isSystemName: true, title: "カメラから", type: .Camera)
                    mediaListView("GoogleDrive", isSystemName: false, title: "Googleドライブから", type: .GoogleDrive)
                }
            }
        }
        .toolbar(.hidden)
        .overlay {
            HStack {
                backBtn
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.leading, 15)
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    func mediaListView(_ systemName: String, isSystemName: Bool, title: String, type: MediaType) -> some View {
        Button(action: {
            switch type {
            case .PhotoLibrary:
                routeView.push(.PhotoLibrary)
            case .DrawPicture:
                routeView.push(.Canvas)
            case .Unsplash:
                routeView.push(.Unsplash)
            case .Camera:
                routeView.push(.Camera)
            case .GoogleDrive:
                routeView.push(.GoogleDrive)
            }
        }) {
            HStack(alignment: .center) {
                if isSystemName {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                } else {
                    Image(systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                Text(title)
                    .font(.system(size: 15, weight: .light))
                Spacer()
            }
            .foregroundStyle(.black)
            .frame(height: 30)
        }
    }
    
    @ViewBuilder
    var backBtn: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
        }
    }
}

//
//  MessageCoverImageView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/27.
//

import SwiftUI

struct MessageCoverImageView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var covertype: Int = 0
    @State private var selectedImage: UIImage? = nil
    
    @Binding var coverImage: UIImage?
    
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Button(action: {
                    self.coverImage = self.selectedImage
                    dismiss()
                }) {
                    Text("決定")
                        .font(.headline)
                        .foregroundStyle(self.selectedImage == nil ? .gray : .blue)
                        .disabled(self.selectedImage == nil ? true : false)
                }
            }
            header
            TabView(selection: $covertype) {
                MessageLibraryView(selectedImage: $selectedImage)
                    .tag(0)
                MessageURLImageView(selectedImage: $selectedImage)
                    .tag(1)
                MessageUnsplashView(selectedImage: $selectedImage, isrouteView: false)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .background(.white)
    }
    
    @ViewBuilder
    var header: some View {
        HStack(alignment: .center, spacing: 20) {
            headerSection(systemName: "photo.artframe", title: "ライブラリ", system: true, covertype: 0)
            headerSection(systemName: "network", title: "URLから", system: true, covertype: 1)
            headerSection(systemName: "unsplash", title: "Unsplash", system: false, covertype: 2)
        }
    }
    
    @ViewBuilder
    func headerSection(systemName: String, title: String, system: Bool, covertype: Int) -> some View {
        Button(action: {
            withAnimation {
                self.covertype = covertype
            }
        }) {
            VStack {
                HStack(alignment: .center) {
                    if system {
                        Image(systemName: systemName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black.opacity(0.8))
                    } else {
                        Image(systemName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.8))
                }
                if (self.covertype == covertype) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black.opacity(0.8))
                        .matchedGeometryEffect(id: "underline", in: namespace)
                } else {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.clear)
                }
            }
        }
    }
}


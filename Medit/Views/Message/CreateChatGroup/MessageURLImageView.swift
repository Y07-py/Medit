//
//  MessageURLImageView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageURLImageView: View {
    @State private var searchText: String = ""
    @State private var imageurl: String = ""
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            TextField("画像URLを貼る。", text: $searchText)
                .onSubmit {
                    self.imageurl = self.searchText
                }
                .submitLabel(.search)
            WebImage(url: URL(string: imageurl))
                .onSuccess { image, data, cacheType in
                    self.selectedImage = image.withRenderingMode(.automatic)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}



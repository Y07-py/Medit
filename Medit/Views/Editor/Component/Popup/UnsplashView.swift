//
//  UnsplashView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/04.
//

import SwiftUI
import SDWebImageSwiftUI

struct UnsplashView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    @StateObject var postView: PostViewModel = PostViewModel(urlType: .Unsplash)
    
    @State private var searchText: String = ""
    @State private var contentHeight: CGFloat = .zero
    @State private var selectedURL: String = ""
    
    @Binding var selectedImage: UIImage?
    
    let isrouteView: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            if isrouteView {
                Header
            }
            SearchBar
            ScrollViewReader { scrollReader in
                ScrollView(.vertical) {
                    VStack {
                        HStack(alignment: .top) {
                            VStack {
                                ForEach(postView.leftPostData) { item in
                                    VStack(alignment: .leading) {
                                        SDWebImageView(url: item.urls.regular, isrouteView: isrouteView, selectedImage: $selectedImage, selectedURL: $selectedURL)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(self.selectedURL == item.urls.regular ? .blue : .gray.opacity(0.2), lineWidth: 1)
                                            }
                                            .environmentObject(routeView)
                                        Text("提供者: " + item.user.name)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                            .padding(.leading, 10)
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                            VStack {
                                ForEach(postView.rightPostData) { item in
                                    VStack(alignment: .leading) {
                                        SDWebImageView(url: item.urls.regular, isrouteView: isrouteView, selectedImage: $selectedImage, selectedURL: $selectedURL)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(self.selectedURL == item.urls.regular ? .blue : .gray.opacity(0.2), lineWidth: 1)
                                            }
                                            .environmentObject(routeView)
                                        Text("提供者: " + item.user.name)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                            .padding(.leading, 10)
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                        .padding()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle.circular)
                    }
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onChange(of: proxy.frame(in: .named("scroll")).maxY) { oldValue, newValue in
                                    if newValue == self.contentHeight {
                                        Task {
                                            await postView.reloadData()
                                        }
                                    }
                                }
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
            }
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            Task {
                                self.contentHeight = proxy.frame(in: .local).height
                            }
                        }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            if postView.postData.isEmpty {
                Task {
                    await postView.fetchData()
                }
            }
        }
    }
    
    @ViewBuilder
    var Header: some View {
        HStack {
            Button(action: {
                routeView.pop(1)
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
                    .contentShape(Rectangle())
            }
            Spacer()
              
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: 40)
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    var SearchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
                .padding()
            TextField("イメージの検索", text: $searchText)
                .onSubmit {
                    if searchText.isEmpty {
                        return
                    } else {
                        Task {
                            await postView.searchData(searchTerm: searchText)
                        }
                    }
                }
                .submitLabel(.search)
        }
        .frame(height: 40)
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.3), lineWidth: 1)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    var SearchTag: some View {
        VStack(alignment: .leading) {
            Text("コレクション")
                .font(.system(size: 18, weight: .medium))
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    TagElement(imageName: "study", title: "勉強")
                    TagElement(imageName: "finance", title: "財務会計")
                    TagElement(imageName: "shopping", title: "買い物")
                    TagElement(imageName: "AI", title: "人工知能")
                    TagElement(imageName: "technology", title: "科学技術")
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func TagElement(imageName: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200)
                .clipShape(Rectangle())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
                .shadow(radius: 3, x:5, y:5)
            Text(title)
                .font(.system(size: 15, weight: .medium))
        }
        .frame(width: 300)
        .padding(.horizontal, 10)
    }
}

fileprivate struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}




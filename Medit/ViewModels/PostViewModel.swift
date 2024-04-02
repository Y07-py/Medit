//
//  PostViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/12.
//

import Foundation
import SwiftUI

enum BaseURL: Hashable {
    case Unsplash
}

enum CurrentType {
    case normal
    case search
}

@MainActor
class PostViewModel: ObservableObject {
    @Published var postData: [Post] = [Post]()
    @Published var rightPostData: [Post] = [Post]()
    @Published var leftPostData: [Post] = [Post]()
    @Published var page: Int = 2
    @Published var baseURL: String

    let defaultURL: String = "https://api.unsplash.com/photos/?client_id="
    let searchURL: String = "https://api.unsplash.com/search/photos/?client_id="
    
    var currentType: CurrentType = .normal
    
    init(urlType: BaseURL) {
        switch urlType {
        case .Unsplash:
            self.baseURL = self.defaultURL
            if let accesskey: String = Bundle.main.infoDictionary?["ACCESS_KEY"] as? String {
                self.baseURL += accesskey
            } 
        }
    }
    
    func fetchData() async {
        guard let downloadedPosts: [Post] = await NetWorkController().downloadData(fromURL: self.baseURL) else { return }
        self.sortingPostData(downloadedPosts)
        self.postData = downloadedPosts
    }
    
    func reloadData() async {
        let url: String = self.baseURL + "&page=" + String(page)
        switch self.currentType {
        case .normal:
            guard let downloadedPosts: [Post] = await NetWorkController().downloadData(fromURL: url) else { return }
            self.sortingPostData(downloadedPosts)
            self.postData += downloadedPosts
        case .search:
            guard let downloadedPosts: SearchPost = await NetWorkController().downloadData(fromURL: url) else { return }
            self.sortingPostData(downloadedPosts.results)
            self.postData += downloadedPosts.results
        }
        self.page += 1
    }
    
    func searchData(searchTerm: String) async {
        self.rightPostData.removeAll()
        self.leftPostData.removeAll()
        if let accessKey: String = Bundle.main.infoDictionary?["ACCESS_KEY"] as? String {
            self.baseURL = self.searchURL + accessKey + "&query='\(searchTerm)'" + "&lang=ja"
            guard let downloadedPosts: SearchPost = await NetWorkController().downloadData(fromURL: self.baseURL) else { return }
            self.sortingPostData(downloadedPosts.results)
            self.postData = downloadedPosts.results
            self.currentType = .search
        }
    }
    
    func sortingPostData(_ postData: [Post]) {
        for (index, item) in postData.enumerated() {
            if index%2 == 0 {
                self.leftPostData.append(item)
            } else {
                self.rightPostData.append(item)
            }
        }
    }
}

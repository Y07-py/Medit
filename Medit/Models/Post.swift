//
//  Post.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/12.
//

import Foundation

struct Post: Identifiable, Codable {
    var id: String
    var width: CGFloat
    var height: CGFloat
    var altDescription: String?
    var urls: ImageURL
    var user: User
    
    private enum CodingKeys: String, CodingKey{
        case id
        case width
        case height
        case altDescription = "alt_description"
        case urls
        case user
    }
}

struct SearchPost: Codable {
    var results: [Post]
}

struct ImageURL: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
    var smalls3: String
    
    private enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smalls3 = "small_s3"
    }
}

struct User: Codable {
    var id: String
    var name: String
}

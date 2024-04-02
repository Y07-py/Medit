//
//  FirebaseUserModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/16.
//

import Foundation
import SwiftUI

struct FirebaseUserModel: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var password: String
    var profile: String
    var chatgroup: [String]
    var chatroom: [String]
    var chatrequest: [String]
    var grouprequest: [String]
}

struct FirebaseModel: Identifiable, Hashable {
    var id: String
    var username: String
    var email: String
    var profile: String
    var coverImage: UIImage?
    // var friends
    // var communites
}

// upload chatdata
struct FirebaseChatGroup: Identifiable, Codable {
    var id: String
    var groupname: String
    var users: [String]
    var messages: [ChatMessage]
}

struct ChatMessage: Identifiable, Codable {
    var id: String
    var message: String?
    var imageData: Data?
}

// download chatdata
struct ChatGroup: Identifiable {
    var id: String
    var groupname: String
    var users: [ChatUser]
    var message: [ChatGroupMessage]
    var coverimage: UIImage?
}

struct ChatGroupMessage: Identifiable, Hashable {
    var id: String
    var username: String
    var message: String?
    var icon: UIImage?
}

struct ChatUser: Identifiable {
    var id: String
    var username: String
    var icon: UIImage
}


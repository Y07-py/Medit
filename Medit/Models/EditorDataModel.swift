//
//  EditorDataModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/31.
//

import Foundation
import SwiftUI

struct EditorDataTaskModel: Identifiable {
    var id: UUID = .init()
    var datalist: [EditorDataBaseModel]?
    var createdAt: Date
    var emoji: String
    var status: StatusType
    var coverImage: Image
    var title: String
    var user: ActiveUser
}

struct EditorDataDocumentModel: Identifiable {
    var id: UUID = .init()
    var datalist: [EditorDataBaseModel]?
    var createdAt: Data
    var user: ActiveUser
    var links: [URLLink]?
    var coverImage: Image
    var title: String
}

struct EditorDataMemoModel: Identifiable {
    var id: UUID = .init()
    var datalist: [EditorDataBaseModel]?
    var createdAt: Data
    var coverImage: Image
    var title: String
    var user: ActiveUser
}

struct EditorDataBaseModel: Identifiable {
    var id: UUID = .init()
    var createdDate: Date = .init()
    var textData: EditorDataTextModel?
    var mediaData: EditorDataMediaModel?
    var listType: listType = .normal
    var separateHeight: CGFloat? = nil
    var lineNumber: Int = 1
    var lineEdgeInsets: EdgeInsets = .init(top: 5, leading: 20, bottom: 0, trailing: 20)
    var children: [EditorDataBaseModel]? = []
    var textAlignment: textAlignment = .left
}

enum textAlignment: String {
    case left
    case center
    case right
}

enum StatusType {
    case waiting
    case doing
    case done
}

struct EditorDataTextModel {
    var text: String = ""
    var textSize: CGFloat
    var textColor: Color
    var textFont: String
    var textFormat: Format = .normal
    
    enum Format: String {
        case normal
        case markdown
    }
}

struct URLLink: Identifiable {
    var id: UUID = .init()
    var link: URL
}


struct EditorDataMediaModel {
    var image: UIImage
    
//    var table: NSData
}

struct ActiveUser: Identifiable {
    var id: UUID = .init()
    var name: String
    var age: Int
    var gender: Gender
    var email: String
    var password: String
    var createdat: Data
    var userimage: Image
    var profile: String
    var friends: [ActiveUser]?
    
    enum Gender {
        case man
        case femail
    }
}

enum listType: String {
    case task
    case folding
    case bullet
    case numbers
    case block
    case line
    case separate
    case normal
}

//
//  MediaModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/02.
//

import Foundation
import SwiftUI

struct MediaModel: Identifiable {
    var id: UUID = .init()
    var mediaType: MediaType
}

enum MediaType: String {
    case photo
    case camera
    case folder
}

enum CropType: String {
    case selected
    case cancel
}


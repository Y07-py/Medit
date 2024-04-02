//
//  SentenceModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/28.
//

import Foundation
import SwiftUI

struct SentenceModel: Identifiable {
    var id: UUID = .init()
    var sentencetype: SentenceType
}

struct SentenceType {
    var basic: Basic?
    var media: Media?
    var database: Database?
    var advanst: Advanst?
    
    enum Basic {
        case text
        case page
        case todolist
        case title1
        case title2
        case title3
        case table
        case bulletlist
        case numberlist
        case togglelist
        case quote
        case separator
        case pagelink
        case callout
    }
    
    enum Media {
        case image
        case webbookmark
        case video
        case audio
        case code
        case file
    }
    
    enum Database {
        case tableview
        case boardview
        case galleryview
        case listview
        case calendarview
        case timelineview
        case databaseinline
        case databasefullpage
        case linkedview
    }
    
    enum Advanst {
        case menu
        case equationblock
        case button
        case hierarchylink
        case synchronizationblock
        case toggletitle1
        case toggletitle2
        case toggletitle3
        case codemermaid
    }
}



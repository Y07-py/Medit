//
//  CalendarModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/06.
//

import Foundation
import SwiftUI

struct MonthModel: Identifiable {
    var id: UUID = .init()
    var date: Date
    var days: [DayModel]
    var index: Int
}

struct DayModel: Identifiable {
    var id: UUID = .init()
    var date: Date
    var index: Int
    var dateModel: [TimeModel]
    var tasks: [EditorTaskModel]? = nil
}

struct TimeModel: Identifiable {
    var id: UUID = .init()
    var date: Date
}



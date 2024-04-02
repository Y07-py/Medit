//
//  Item.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/20.
//

import Foundation
import SwiftUI

struct Item<T>: Identifiable {
    var id: UUID = .init()
    var data: T
}

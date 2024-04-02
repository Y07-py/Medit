//
//  Route.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/17.
//

import Foundation
import SwiftUI

class Router<Route: Equatable>: ObservableObject {
    var routes: [Route] = [Route]()
    
    var onPush: ((Route) -> Void)?
    
    init(initial: Route? = nil) {
        if let initial = initial {
            self.routes.append(initial)
        }
    }
    
    func push(_ route: Route) {
        routes.append(route)
        onPush?(route)
    }
}

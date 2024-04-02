//
//  NavigationRouterViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/03.
//

import Foundation
import SwiftUI

class NavigationRouterViewModel<Route: Equatable>: ObservableObject {
    var routes = [Route]()
    
    var onPush: ((Route) -> Void)?
    var onPop: ((_ count: Int) -> Void)?
    
    init(route: Route? = nil) {
        if let route = route {
            self.routes.append(route)
        }
    }
    
    func push(_ route: Route) {
        routes.append(route)
        onPush?(route)
    }
    
    func pop(_ count: Int) {
        routes.removeLast(count)
        onPop?(count)
    }
}

struct RouterHostController<Route: Equatable, Screen: View>: UIViewControllerRepresentable {
    
    let router: NavigationRouterViewModel<Route>
    
    @ViewBuilder
    let builder: (Route) -> Screen
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController: UINavigationController = .init()
        for route in router.routes {
            navigationController.pushViewController(UIHostingController(rootView: builder(route)), animated: false)
        }
        
        router.onPush = { route in
            navigationController.pushViewController(UIHostingController(rootView: builder(route)), animated: true)
            
        }
        
        router.onPop = { count in
            let layerNumber: Int = navigationController.viewControllers.count
            navigationController.popToViewController(navigationController.viewControllers[layerNumber - count - 1], animated: true)
        }
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

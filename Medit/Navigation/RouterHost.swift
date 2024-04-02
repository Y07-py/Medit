//
//  RouterHost.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/17.
//

import Foundation
import SwiftUI

struct RouterHost<Route: Equatable, Screen: View>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UINavigationController
    
    let router: Router<Route>
    
    @ViewBuilder
    let builder: (Route) -> Screen
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigation: UINavigationController = UINavigationController()
        
        for route in router.routes {
            navigation.pushViewController(UIHostingController(rootView: builder(route)), animated: false)
        }
        
        router.onPush = { route in
            navigation.pushViewController(UIHostingController(rootView: builder(route)), animated: true)
        }
        
        return navigation
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
    
}

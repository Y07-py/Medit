//
//  MessageRouteView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/26.
//

import Foundation
import SwiftUI

enum MessageRoute: Hashable {
    case main
    case createchatgroup
    case chatroom
}

struct MessageRouteView: View {
    @StateObject var routeView: NavigationRouterViewModel = NavigationRouterViewModel(route: MessageRoute.main)
    
    var body: some View {
        RouterHostController(router: routeView) { route in
            switch route {
            case .main:
                MessageView()
                    .ignoresSafeArea()
            case .createchatgroup:
                CreateChatGroupView()
                    .ignoresSafeArea()
            case .chatroom:
                ChatRoomView()
            }
        }
        .environmentObject(routeView)
    }
}

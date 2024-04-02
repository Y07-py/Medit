//
//  MainTabView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/25.
//

import SwiftUI
import Combine

struct MainTabView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @State private var isShownPopover: Bool = false
    @State private var popoverOffsetY: CGFloat = UIWindow().bounds.height
    
    var body: some View {
        ZStack {
            CustomTabBar([
                TabBarElement(tabBarElementItem: .init(title: "", systemImageName: "lamp.desk"), {
                    DeskView()
                }),
                TabBarElement(tabBarElementItem: .init(title: "", systemImageName: "doc.plaintext"), {
                    ToDoView()
                }),
                TabBarElement(tabBarElementItem: .init(title: "", systemImageName: "plus.app"), {
                    Text("Hello")
                }),
                TabBarElement(tabBarElementItem: .init(title: "", systemImageName: "message"), {
                    MessageRouteView()
                }),
                TabBarElement(tabBarElementItem: .init(title: "", systemImageName: "person"), {
                    ProfileView()
                })
            ], isShownPopover: $isShownPopover)
            .ignoresSafeArea()
            .background(.white)
            .toolbar(.hidden)
            
            Color
                .black
                .ignoresSafeArea()
                .opacity(isShownPopover ? 0.2 : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isShownPopover.toggle()
                    }
                }
                
            PopupView()
                .frame(width: UIWindow().bounds.width - 20, height: 380)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .offset(y: popoverOffsetY)
                .onChange(of: isShownPopover) { _, value in
                    if value {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            popoverOffsetY = UIWindow().bounds.height / 2 - UIWindow().bounds.width * 0.55
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            popoverOffsetY = UIWindow().bounds.height
                        }
                    }
                }
                .environmentObject(routeView)
        }
    }
}

fileprivate struct TabBarController: UIViewControllerRepresentable {
    
    var viewController: [UIViewController]
    
    @Binding var isShownPopover: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, isShownPopover: $isShownPopover)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarController>) -> UITabBarController {
        let tabBarController: UITabBarController = UITabBarController()
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor = UIColor.gray.cgColor
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.delegate = context.coordinator
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        uiViewController.setViewControllers(self.viewController, animated: false)
        uiViewController.tabBar.tintColor = .black
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        
        var parent: TabBarController
        @Binding var isShownPopover: Bool
        
        init(parent: TabBarController, isShownPopover: Binding<Bool>) {
            self.parent = parent
            self._isShownPopover = isShownPopover
        }
        
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            guard let selectedIndex: Int = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }
            if selectedIndex == 2 {
                withAnimation(.easeIn) {
                    self.isShownPopover = true
                }
                return false
            }
            withAnimation(.easeIn) {
                self.isShownPopover = false
            }
            return true
        }
    }
}

struct TabBarElementItem {
    var title: String
    var systemImageName: String
}

protocol TabBarElementView: View {
    associatedtype Content
    
    var content: Content { get set }
    var tabBarElementItem: TabBarElementItem { get set }
}

struct TabBarElement: TabBarElementView {
    internal var content: AnyView
    
    var tabBarElementItem: TabBarElementItem
    
    init<Content: View>(tabBarElementItem: TabBarElementItem, @ViewBuilder _ content: () -> Content) {
        self.content = AnyView(content())
        self.tabBarElementItem = tabBarElementItem
    }
    
    var body: some View {
        self.content
    }
}

struct CustomTabBar: View {
    var controllers: [UIHostingController<TabBarElement>]
    
    @Binding var isShownPopover: Bool
    
    init(_ elements: [TabBarElement], isShownPopover: Binding<Bool>) {
        self.controllers = elements.enumerated().map {
            let hostingController: UIHostingController = UIHostingController(rootView: $1)
            hostingController.tabBarItem = UITabBarItem(title: $1.tabBarElementItem.title, image: UIImage.init(systemName: $1.tabBarElementItem.systemImageName), tag: $0)
            return hostingController
        }
        self._isShownPopover = isShownPopover
    }
    
    var body: some View {
        TabBarController(viewController: self.controllers, isShownPopover: $isShownPopover)
    }
}

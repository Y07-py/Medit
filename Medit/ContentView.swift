//
//  ContentView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/06.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var calendarView: CalendarViewModel = CalendarViewModel()
    @ObservedObject private var editorMasterController: EditorMasterControllerViewModel = EditorMasterControllerViewModel()
    @ObservedObject private var firebaseAuthView: FirebaseAuthControllerViewModel = FirebaseAuthControllerViewModel()
    
    var body: some View {
        ZStack {
            if let isSignedin: Bool = self.firebaseAuthView.isSignedin {
                if isSignedin {
                    MainRouteView()
                        .environmentObject(calendarView)
                        .environmentObject(editorMasterController)
                } else {
                    EnterRouteView()
                }
            } else {
                Color.white.ignoresSafeArea()
            }
        }
        .environmentObject(firebaseAuthView)
    }
}

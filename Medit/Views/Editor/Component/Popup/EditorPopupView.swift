//
//  EditorPopupView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/30.
//

import SwiftUI
import Combine

enum AppRoute: Equatable {
    case Menu
    case List
    case Indent
    case Color
    case Font
    case Date
    case Format
    case Position
    case Decoration
    case Separator
    case Media
    case Clear
    case Code
}

struct EditorPopupView: View {
    @EnvironmentObject var editorModel: EditorViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    @EnvironmentObject var editorController: EditorControllerViewModel
    @State private var path: [Int] = [Int]()
    @State private var isBool: Bool = false
    @Binding var popupHeight: CGFloat
    @Binding var popupWidth: CGFloat
    
    @StateObject var router: Router = Router(initial: AppRoute.Menu)
    
    let isheaderPopup: Bool
    let lineid: String?
    
    var body: some View {
        RouterHost(router: router) { route in
            switch route {
            case .Menu: PopupListView(popupHeight: $popupHeight, popupWidth: $popupWidth, isHeader: isheaderPopup)
            case .List: EditorListView()
            case .Indent: EditorIndentView()
            case .Color: EditorColorSelectView()
            case .Font: EditorFontSelectView()
            case .Date: EditorDateView()
            case .Format: EditorFormatView()
            case .Position: EditorPositionView()
            case .Decoration: EditorDecorationView()
            case .Separator: EditorSeparatorView(lineId: lineid)
            case .Media: EditorMediaView()
            case .Clear: EditorStyleClearView()
            case .Code: EditorCodeView(popupHeight: $popupHeight, popupWidth: $popupWidth)
            }
        }
        .frame(width: popupWidth, height: popupHeight)
        .environmentObject(router)
        .environmentObject(editorModel)
        .environmentObject(routeView)
        .environmentObject(editorController)
    }
}

fileprivate struct PopupListView: View {
    @Binding var popupHeight: CGFloat
    @Binding var popupWidth: CGFloat
    let isHeader: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                if (!isHeader) {
                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "list.bullet", isSystemName: true, title: "リスト", width: 20, height: 20, route: .List)
                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "photo.stack", isSystemName: true, title: "ファイルまたはメディア", width: 20, height: 20, route: .Media)
                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "arrow.up.and.down.text.horizontal", isSystemName: true, title: "配置", width: 20, height: 20, route: .Position)
//                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "lasso", isSystemName: true, title: "装飾", width: 20, height: 20, route: .Decoration)
                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "pencil.and.scribble", isSystemName: true, title: "区切り線の挿入", width: 20, height: 20, route: .Separator)
                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "list.bullet.indent", isSystemName: true, title: "インデント", width: 20, height: 20, route: .Indent)
                    PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "code", isSystemName: false, title: "コードブロックの挿入", width: 20, height: 20, route: .Code)
                }
                PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "paintbrush", isSystemName: true, title: "カラー", width: 20, height: 20, route: .Color)
                PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "a.square", isSystemName: true, title: "フォント", width: 20, height: 20, route: .Font)
//                PopupListButtonView(systemName: "timer", title: "日付と時刻", width: 20, height: 20, route: .Date)
                PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "textformat", isSystemName: true, title: "テキストフォーマット", width: 20, height: 20, route: .Format)
                PopupListButtonView(popupHeight: $popupHeight, popupWidth: $popupWidth, systemName: "clear", isSystemName: true, title: "スタイルのクリア", width: 20, height: 20, route: .Clear)
            }
            .toolbar(.hidden)
        }
    }
}

fileprivate struct PopupListButtonView: View {
    @EnvironmentObject var router: Router<AppRoute>
    @Binding var popupHeight: CGFloat
    @Binding var popupWidth: CGFloat
    
    let systemName: String
    let isSystemName: Bool
    let title: String
    let width: CGFloat
    let height: CGFloat
    let route: AppRoute
    
    var body: some View {
        Button(action: {
            if route == .Code {
                withAnimation {
                    self.popupHeight = 400
                    self.popupWidth = 400
                }
            }
            router.push(route)
        }) {
            HStack(alignment: .center) {
                if isSystemName {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                        .padding(.horizontal, 5)
                } else {
                    Image(systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                        .padding(.horizontal, 5)
                }
                Text(title)
                    .font(.system(size: 15, weight: .light))
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(.gray)
            }
            .frame(height: 15)
            .foregroundStyle(.black)
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}

fileprivate struct DestinationView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    let content: () -> Content
    
    var body: some View {
            content()
            .navigationBarBackButtonHidden(true)
    }
}

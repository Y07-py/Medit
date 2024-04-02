//
//  PopupView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/26.
//

import SwiftUI

enum EditorRoute: Equatable {
    case Document
    case Task
    case File
    case Menu
}

struct PopupView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    
    var body: some View {
        PopupListView()
            .environmentObject(routeView)
            .environmentObject(editorMasterController)
    }
}

fileprivate struct PopupListView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            listView("ドキュメントを追加", systemName: "doc", type: .DocumentEditor, color: .init(hex: "#6C00FF"), description: "思考やナレッジの整理")
            listView("タスクを追加", systemName: "pencil.and.list.clipboard", type: .TaskEditor, color: .init(hex: "#3C79F5"), description: "これからのToDoを明確に")
            listView("メモをとる", systemName: "highlighter", type: .MemoEditor, color: .init(hex: "#2DCDDF"), description: "ふとした瞬間のために")
            listView("フォルダを作成", systemName: "folder", type: .FileEditor, color: .init(hex: "#F2DEBA"), description: "データの整理のために")
        }
    }
    
    @ViewBuilder
    func listView(_ title: String, systemName: String, type: Route, color: Color, description: String) -> some View {
        Button(action: {
            self.editorMasterController.selectedTaskModel = nil
            self.editorMasterController.selectedDocumentModel = nil
            self.editorMasterController.selectedMemoModel = nil
            routeView.push(type)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(.leading, 20)
                    .foregroundStyle(color)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .frame(width: UIWindow().bounds.width - 40, height: 80)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 1)
            }
            .background(color.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(RoundedRectangle(cornerRadius: 50))
        }
    }
}


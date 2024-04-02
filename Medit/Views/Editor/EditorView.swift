//
//  EditorView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/28.
//

import SwiftUI
import Combine

struct EditorView<Content: View>: View {
    @EnvironmentObject private var editorController: EditorControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>

    @State private var mediaSheetActive: Bool = false
    @State private var protrudingLineId: String?
    @State private var currentLineId: String? = ""
    @State private var viewHeight: CGFloat = 0
    
    @Binding var isdeadLineActive: Bool
    @Binding var iskeyboardActive: Bool
    
    @FocusState private var focusReminder: Focusable?
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    content() // header
                    VStack(spacing: 0) {
                        ForEach(editorController.lineList) { line in
                            Group {
                                if line.listType == .separate {
                                    if let separateheight = line.separateHeight {
                                        Rectangle()
                                            .frame(height: separateheight / 2)
                                            .foregroundStyle(.black.opacity(0.8))
                                            .padding(.horizontal, 20)
                                    }
                                } else {
                                    EditorLineView(text: line.textData?.text ,textSize: 17, listtype: line.listType, lineNumber: line.lineNumber, protrudingLineId: $protrudingLineId, viewHeight: $viewHeight, currentLineId: $currentLineId, iskeyboardActive: $iskeyboardActive, paddingLeading: 0, lineId: line.id.uuidString, line: line)
                                        .listRowSeparator(.hidden)
                                        .id(line.id.uuidString)
                                        .environmentObject(editorController)
                                        .focused($focusReminder, equals: .row(id: line.id.uuidString))
                                        .onTapGesture {
                                            self.editorController.isPopupEditor = false
                                        }
                                        .onChange(of: self.iskeyboardActive) { oldValue, newValue in
                                            if (newValue) {
                                                self.editorController.isKeyboardActive = newValue
                                                
                                                if let lastModel: EditorDataBaseModel = self.editorController.lineList.last {
                                                    if let textData: EditorDataTextModel = lastModel.textData {
                                                        if textData.text.isEmpty {
                                                            self.focusReminder = .row(id: lastModel.id.uuidString)
                                                            return
                                                        }
                                                    } else if lastModel.listType == .separate {
                                                        let baseModel: EditorDataBaseModel = .init()
                                                        self.editorController.lineList.append(baseModel)
                                                        self.focusReminder = .row(id: baseModel.id.uuidString)
                                                        return
                                                    } else {
                                                        self.focusReminder = .row(id: lastModel.id.uuidString)
                                                        return
                                                    }
                                                }
                                                let baseModel: EditorDataBaseModel = .init()
                                                self.editorController.lineList.append(baseModel)
                                                self.focusReminder = .row(id: baseModel.id.uuidString)
                                            } else {
                                                self.editorController.isTapped = false
                                            }
                                            
                                            if self.editorController.lineList.isEmpty {
                                                let baseModel: EditorDataBaseModel = .init()
                                                self.editorController.lineList.append(baseModel)
                                                self.focusReminder = .row(id: baseModel.id.uuidString)
                                            }
                                        }
                                        .onChange(of: editorController.focusReminder) { oldValue, newValue in
                                            self.focusReminder = newValue
                                        }
                                        .onChange(of: focusReminder) { oldValue, newValue in
                                            self.editorController.focusReminder = newValue
                                        }
                                        .environmentObject(routeView)
                                        .onChange(of: self.editorController.returnedLineId ?? "") { oldValue, newValue in
                                            focusReminder = .row(id: newValue)
                                        }
                                        .onTapGesture {
                                            self.currentLineId = line.id.uuidString
                                        }
                                }
                            }
                            .id(line.id.uuidString)
                        }
                        Spacer()
                            .frame(height: UIWindow().bounds.height/2)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .onChange(of: editorController.lineList.count) { _, _ in
                        guard let lastModel: EditorDataBaseModel = self.editorController.lineList.last else { return }
                        withAnimation {
                            proxy.scrollTo(lastModel.id.uuidString, anchor: .center)
                        }
                    }
                    .onChange(of: focusReminder) { _ , _ in
                        guard let currentLineid: String = self.currentLineId else { return }
                        if let index: Int = self.editorController.lineList.firstIndex(where: {$0.id.uuidString == currentLineid}) {
                            withAnimation {
                                proxy.scrollTo(self.editorController.lineList[index].id.uuidString, anchor: .center)
                            }
                        }
                    }
                    .onChange(of: currentLineId) { _, newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            .onTapGesture { cgpoint in
                if cgpoint.y < 200 {
                    return
                }
                withAnimation {
                    if self.editorController.lineList.isEmpty {
                        let baseModel: EditorDataBaseModel = .init()
                        self.editorController.lineList.append(baseModel)
                        self.focusReminder = .row(id: baseModel.id.uuidString)
                    } else {
                        if let lastModel: EditorDataBaseModel = self.editorController.lineList.last {
                            if lastModel.textData == nil {
                                let newModel: EditorDataBaseModel = .init()
                                self.editorController.lineList.append(newModel)
                                self.focusReminder = .row(id: newModel.id.uuidString)
                            }
                        }
                    }
                    self.mediaSheetActive = false
                    if self.focusReminder == nil {
                        if let lastModel: EditorDataBaseModel = self.editorController.lineList.last {
                            self.focusReminder = .row(id: lastModel.id.uuidString)
                        }
                    } else {
                        self.focusReminder = nil
                    }
                }
            }
            .onChange(of: iskeyboardActive) { _, value in
                if value, self.editorController.lineList.isEmpty {
                    let baseModel: EditorDataBaseModel = .init()
                    self.editorController.lineList.append(baseModel)
                    self.focusReminder = .row(id: baseModel.id.uuidString)
                }
            }
            
            TextKeyBoardView(isMediaSheetActive: $mediaSheetActive, isKeyBoardActive: $iskeyboardActive)
                .environmentObject(editorController)
                .environmentObject(routeView)
        }
    }
}

struct EditorLineView: View {
    @StateObject var editorModel: EditorViewModel = EditorViewModel()
    @EnvironmentObject var editorController: EditorControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MediaRoute>
    
    @State var text: String?
    @State var textSize: CGFloat
    @State var listtype: listType
    @State var lineNumber: Int
    @State private var isPopupEditor: Bool = false
    
    @State private var degree: Double = 0
    
    @State private var popupHeight: CGFloat = 200
    @State private var popupWidth: CGFloat = 270
    
    @Binding var protrudingLineId: String?
    @Binding var viewHeight: CGFloat
    @Binding var currentLineId: String?
    @Binding var iskeyboardActive: Bool
        
    let paddingLeading: CGFloat
    let lineId: String
    @State var line: EditorDataBaseModel
        
    var body: some View {
        if let mediaData = line.mediaData {
            Image(uiImage: mediaData.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 20)
        } else {
            HStack(spacing: 0) {
                switch listtype {
                case .task:
                    Group {
                        if (editorModel.istaskChecked) {
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.black)
                        } else {
                            Image(systemName: "square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.trailing, 10)
                    .contentShape(RoundedRectangle(cornerRadius: 40))
                    .onTapGesture {
                        editorModel.istaskChecked.toggle()
                    }
                case .folding:
                    Group {
                        Image(systemName: "arrowtriangle.right.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.black)
                            .rotationEffect(.degrees(self.degree))
                    }
                    .padding(.trailing, 10)
                    .contentShape(RoundedRectangle(cornerRadius: 40))
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            if degree == 90 {
                                self.degree = 0
                            } else {
                                self.degree = 90
                            }
                        }
                    }
                case .bullet:
                    Circle()
                        .frame(width: 7, height: 7)
                        .foregroundStyle(.black.opacity(0.8))
                        .padding(.trailing, 5)
                case .numbers:
                    Text("\(lineNumber).")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.black.opacity(0.8))
                        .padding(.trailing, 10)
                case .normal:
                    Color.clear
                        .frame(width: 0, height: 0)
                case .block:
                    Color.clear
                        .frame(width: 0, height: 0)
                case .line:
                    Rectangle()
                        .frame(width: 3)
                        .foregroundStyle(.black)
                        .padding(.trailing, 5)
                case .separate:
                    Color.clear
                        .frame(width: 0, height: 0)
                }
                EditorTextView(titleKey: " ", font: .callout, paddingLeading: 0, lineId: lineId, isTitle: false, textAlignment: line.textAlignment, text: $editorModel.text, textSize: $textSize, protrudingLineId: $protrudingLineId, windowHeight: $viewHeight, currentLineId: $currentLineId, isPopupEditor: $isPopupEditor, iskeyboardActive: $iskeyboardActive) {
                    Group {
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.isPopupEditor.toggle()
                            }
                        }) {
                            Image(systemName: "pencil.tip.crop.circle.badge.plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black)
                                .padding(10)
                        }
                        Button(action: {}) {
                            Image(systemName: "pencil.and.scribble")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black)
                                .padding(10)
                        }
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: 80, height: 1)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 30)
                        }
                        Button(action: {}) {
                            Image(systemName: "plus.rectangle.on.rectangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black)
                                .padding(10)
                        }
                        Button(action: {}) {
                            Image(systemName: "link")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black)
                                .padding(10)
                        }
                    }
                }
                .environmentObject(editorModel)
                .environmentObject(editorController)
            }
            .onAppear {
                Task {
                    editorModel.listtype = self.listtype
                    editorModel.rowEdgeInsets = self.line.lineEdgeInsets
                    editorModel.lineNumber = self.lineNumber
                    editorModel.textAlignment = self.line.textAlignment
                    if let text: String = self.text {
                        editorModel.text = text
                    }
                }
            }
            .padding(.leading, line.lineEdgeInsets.leading)
            .padding(.trailing, 20)
            .onChange(of: editorModel.rowEdgeInsets) { oldValue, newValue in
                if let index: Int = self.editorController.lineList.firstIndex( where: {$0.id.uuidString == self.lineId }) {
                    self.editorController.lineList[index].lineEdgeInsets = self.editorModel.rowEdgeInsets
                    line.lineEdgeInsets = self.editorModel.rowEdgeInsets
                    if oldValue.leading < newValue.leading {
                        if index > 0 {
                            if self.editorController.lineList[index-1].lineEdgeInsets.leading < self.line.lineEdgeInsets.leading {
                                self.lineNumber = 1
                                self.editorModel.lineNumber = 1
                                self.editorController.lineList[index].lineNumber = 1
                            }
                            var prevLine: EditorDataBaseModel = self.editorController.lineList[index-1]
                            for i in index + 1 ..< self.editorController.lineList.count {
                                if self.editorController.lineList[i].lineEdgeInsets.leading == prevLine.lineEdgeInsets.leading { self.editorController.lineList[i].lineNumber = prevLine.lineNumber + 1
                                    self.editorModel.lineNumber = self.lineNumber
                                    prevLine.lineNumber += 1
                                }
                            }
                            if lineNumber != 1 {
                                for i in index ..< self.editorController.lineList.count {
                                    let previtem: EditorDataBaseModel = self.editorController.lineList[i-1]
                                    if previtem.lineEdgeInsets.leading == self.editorController.lineList[i].lineEdgeInsets.leading {
                                        self.editorController.lineList[i].lineNumber = previtem.lineNumber + 1
                                    } else {
                                        break
                                    }
                                }
                                self.editorController.islineNumberChanged.toggle()
                            }
                        }
                        
                    } else {
                        if index > 0 {
                            if self.editorController.lineList[index-1].listType == .numbers {
                                for i in (0 ..< index).reversed() {
                                    if self.editorController.lineList[i].lineEdgeInsets.leading == self.editorModel.rowEdgeInsets.leading {
                                        if self.editorController.lineList[index].id.uuidString == self.lineId {
                                            self.lineNumber = self.editorController.lineList[i].lineNumber + 1
                                            self.editorController.lineList[index].lineNumber = self.lineNumber
                                            self.editorModel.lineNumber = self.lineNumber
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self.line.lineEdgeInsets = self.editorModel.rowEdgeInsets
            }
            .onChange(of: editorModel.listtype) { oldValue, newValue in
                self.listtype = newValue
                DispatchQueue.main.async {
                    if let index: Int = self.editorController.lineList.firstIndex(where: {$0.id.uuidString == self.lineId }) {
                        self.editorController.lineList[index].listType = newValue
                    }
                }
                editorController.currentLineType = newValue
            }
            .onChange(of: routeView.routes, { _, _ in
                withAnimation {
                    self.isPopupEditor = false
                }
            })
            .onChange(of: editorController.lineList.count) { oldValue, newValue in
                if oldValue < newValue {
                    for item in self.editorController.lineList {
                        if item.id.uuidString == lineId {
                            self.lineNumber = item.lineNumber
                            self.editorModel.lineNumber = item.lineNumber
                        }
                    }
                } else {
                    for i in 0 ..< self.editorController.lineList.count-1 {
                        var item: EditorDataBaseModel = self.editorController.lineList[i]
                        let nextItem: EditorDataBaseModel = self.editorController.lineList[i+1]
                        if item.lineNumber != nextItem.lineNumber {
                            if nextItem.id.uuidString == lineId {
                                self.editorController.lineList[i+1].lineNumber = item.lineNumber + 1
                                self.lineNumber = item.lineNumber + 1
                                item.lineNumber += 1
                            }
                        }
                    }
                }
            }
            .onChange(of: editorController.islineNumberChanged) { oldValue, newValue in
                if newValue {
                    if let index: Int = self.editorController.lineList.firstIndex(where: {$0.id.uuidString == lineId }) {
                        if lineId == self.editorController.lineList[index].id.uuidString {
                            self.lineNumber = self.editorController.lineList[index].lineNumber
                            self.editorModel.lineNumber = self.lineNumber
                        }
                    }
                }
            }
            .onChange(of: isPopupEditor) { _, value in
                Task {
                    self.popupHeight = 180
                    self.popupWidth = 270
                }
            }
            .onChange(of: editorModel.textAlignment, { _, value in
                Task {
                    if let index: Int = self.editorController.lineList.firstIndex(where: {$0.id.uuidString == lineId }) {
                        self.editorController.lineList[index].textAlignment = value
                    }
                }
            })
            .popover(isPresented: $isPopupEditor) {
                EditorPopupView(popupHeight: $popupHeight, popupWidth: $popupWidth, isheaderPopup: false, lineid: self.lineId)
                    .ignoresSafeArea()
                    .environmentObject(editorModel)
                    .environmentObject(routeView)
                    .environmentObject(editorController)
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
}


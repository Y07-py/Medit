//
//  EditorTextView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/28.
//

import SwiftUI
import UIKit
import Combine

struct EditorTextView<Content: View>: View {
    @EnvironmentObject var editorModel: EditorViewModel
    @EnvironmentObject var editorController: EditorControllerViewModel
    
    let titleKey: String
    let font: Font
    let paddingLeading: CGFloat
    let lineId: String?
    let isTitle: Bool
    let textAlignment: textAlignment
    
    @Binding var text: String
    @Binding var textSize: CGFloat
    @Binding var protrudingLineId: String?
    @Binding var windowHeight: CGFloat
    @Binding var currentLineId: String?
    @Binding var isPopupEditor: Bool
    @Binding var iskeyboardActive: Bool
    
    @State private var viewHeight: CGFloat = 46
    @State private var didStartEditing: Bool = false
    @State private var isFirst: Bool = false
    @State private var linePositionY: CGFloat?
    
    @FocusState private var focusReminder: Focusable?
    
    let content: () -> Content
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            CustomTextField(cursorPositionX: $editorModel.cursorPositionX, cursorPositionY: $editorModel.cursorPositionY, currentLineID: $currentLineId, text: $text, textColor: $editorModel.textColor, textColorSelected: $editorModel.textColorSelected, textFontTitle: $editorModel.textFontTitle, textFontSelected: $editorModel.textFontSelected, isTitle: isTitle, removedId: $editorController.removedIndex, linetype: $editorModel.listtype, lineid: lineId ?? "", placeholder: titleKey, textSize: $textSize, height: $viewHeight, didStartEditing: $didStartEditing, tempCursorPosition: $editorModel.tempCursorPosition, lineList: $editorController.lineList, returnedLineid: $editorController.returnedLineId, rowEdgeInsets: $editorModel.rowEdgeInsets, isPopupEditor: $isPopupEditor, isIncreaseIndent: $editorModel.isIncreaseIndent, isDecreaseIndent: $editorModel.isDecreaseIndent, textAlignment: textAlignment) {
                HStack(alignment: .center) {
                    content()
                    Spacer()
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.2)) {
                            didStartEditing = false
                            isPopupEditor = false
                            focusReminder = nil
                            iskeyboardActive = false
                        }
                    }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundStyle(.black)
                            .padding(10)
                    }
                }
                .padding(.horizontal, 10)
                .overlay {
                    Rectangle()
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
            }
            .onTapGesture {
                focusReminder = .row(id: lineId ?? "")
                didStartEditing.toggle()
                currentLineId = lineId
                self.editorController.selectedlineId = lineId
            }
            .onChange(of: editorModel.text) { oldValue, newValue in
                DispatchQueue.main.async {
                    if let index: Int = self.editorController.lineList.firstIndex(where: {$0.id.uuidString == lineId }) {
                        if var textData: EditorDataTextModel = self.editorController.lineList[index].textData {
                            textData.text = newValue
                            self.editorController.lineList[index].textData = textData
                        } else {
                            self.editorController.lineList[index].textData = .init(text: newValue, textSize: textSize, textColor: editorModel.textColor, textFont: editorModel.textFontTitle)
                            
                        }
                    }
                }
                withAnimation(.easeOut) {
                    self.isPopupEditor = false
                }
            }
            .frame(height: viewHeight)
            .padding(.horizontal, paddingLeading)
            .environmentObject(editorModel)
            .focused($focusReminder, equals: .row(id: lineId ?? ""))
        }
        .background {
            GeometryReader {
                let frame: CGRect = $0.frame(in: .global)
                let viewHeight: CGFloat = frame.origin.y
                let lineHeight: CGFloat = frame.height
                let linePositionY: CGFloat = viewHeight + lineHeight
                Color.clear
                    .onChange(of: frame) { oldValue, newValue in
                        self.linePositionY = linePositionY
                    }
            }
        }
        .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            let viewHeight: CGFloat = UIWindow().bounds.height
            let keyboardPositionY: CGFloat = viewHeight - keyboardHeight
            if let linePositionY = self.linePositionY {
                if (linePositionY > keyboardPositionY) {
                    self.protrudingLineId = self.currentLineId
                    if (self.currentLineId == lineId) {
                        self.windowHeight = linePositionY - keyboardPositionY
                    }
                } else {
                    self.windowHeight = 0
                }
            }
        }
        .onChange(of: self.editorController.isTapped) { oldValue, newValue in
            if self.editorController.isKeyboardActive {
                if !self.isPopupEditor {
                    self.focusReminder = nil
                    self.editorController.isKeyboardActive = false
                }
                self.editorController.isKeyboardActive = false
            }
        }
    }
}

fileprivate struct CustomTextField<Toolbar: View>: UIViewRepresentable {
    @EnvironmentObject var editorModel: EditorViewModel
    
    @Binding var cursorPositionX: CGFloat
    @Binding var cursorPositionY: CGFloat
    @Binding var currentLIneId: String?
    @Binding var text: String
    @Binding var textColor: Color
    @Binding var textColorSelected: Bool
    @Binding var textFontTitle: String
    @Binding var textFontSelected: Bool
    @Binding var calculatedHeight: CGFloat
    @Binding var textSize: CGFloat
    @Binding var didStartEditing: Bool
    @Binding var tempCursorPosition: CGFloat
    @Binding var lineList: [EditorDataBaseModel]
    @Binding var removedId: Int
    @Binding var linetype: listType
    @Binding var retuendLineId: String?
    @Binding var roeEdgeInsets: EdgeInsets
    @Binding var isPopupEditor: Bool
    @Binding var isIncreaseIndent: Bool
    @Binding var isDecreaseIndent: Bool
    
    let isTitle: Bool
    let lineId: String
    let placeholder: String
    let placeHolderLabel: UILabel
    let textAlignment: textAlignment
    let toolbar: () -> Toolbar
    
    private var subscritions: Set<AnyCancellable> = []
    
    init(cursorPositionX: Binding<CGFloat>, cursorPositionY: Binding<CGFloat>, currentLineID: Binding<String?>, text: Binding<String>, textColor: Binding<Color>, textColorSelected: Binding<Bool>, textFontTitle: Binding<String>, textFontSelected: Binding<Bool>, isTitle: Bool, removedId: Binding<Int>, linetype: Binding<listType>, lineid: String, placeholder: String, textSize: Binding<CGFloat>, height: Binding<CGFloat>, didStartEditing: Binding<Bool>, tempCursorPosition: Binding<CGFloat>, lineList: Binding<[EditorDataBaseModel]>, returnedLineid: Binding<String?>, rowEdgeInsets: Binding<EdgeInsets>, isPopupEditor: Binding<Bool>, isIncreaseIndent: Binding<Bool>, isDecreaseIndent: Binding<Bool>, textAlignment: textAlignment, @ViewBuilder toolbar: @escaping () -> Toolbar) {
        self._cursorPositionX = cursorPositionX
        self._cursorPositionY = cursorPositionY
        self._currentLIneId = currentLineID
        self._text = text
        self._textColor = textColor
        self._textColorSelected = textColorSelected
        self._textFontTitle = textFontTitle
        self._textFontSelected = textFontSelected
        self._removedId = removedId
        self.isTitle = isTitle
        self.lineId = lineid
        self._retuendLineId = returnedLineid
        self._linetype = linetype
        self.placeholder = placeholder
        self._textSize = textSize
        self._calculatedHeight = height
        self._didStartEditing = didStartEditing
        self._tempCursorPosition = tempCursorPosition
        self._lineList = lineList
        self.toolbar = toolbar
        self.textAlignment = textAlignment
        self._roeEdgeInsets = rowEdgeInsets
        self._isPopupEditor = isPopupEditor
        self._isIncreaseIndent = isIncreaseIndent
        self._isDecreaseIndent = isDecreaseIndent
        self.placeHolderLabel = Self.createUILabel(placeholder, color: .lightGray, textSize: textSize.wrappedValue)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, height: $calculatedHeight, cursorPositionX: $cursorPositionX, cursorPositionY: $cursorPositionY, text: $text, textSize: $textSize, placeHolder: placeholder, tempCursorPosition: $tempCursorPosition, lineList: $lineList, isTitle: isTitle, lineid: lineId, removedId: $removedId, linetype: $linetype, returnedLineId: $retuendLineId, rowEdgeInsets: $roeEdgeInsets, isPopupEditor: $isPopupEditor, isIncreaseIndent: $isIncreaseIndent, isDecreaseIndent: $isDecreaseIndent)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textField: UITextView = UITextView(frame: .zero)
        textField.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: textSize))
        textField.text = text
        textField.font = UIFont(name: "NotoSerifJP-Regular", size: textSize)
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.isSelectable = true
        textField.showsVerticalScrollIndicator = false
        textField.isEditable = true
        textField.constrainSize(textField.bounds.size)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.addSubview(placeHolderLabel)
        textField.textContainerInset.left = 0
        textField.keyboardDismissMode = .interactive
        textField.insetsLayoutMarginsFromSafeArea = false
        placeHolderLabel.constrainBottom(in: textField)
        if self.linetype == .block {
            textField.backgroundColor = .gray.withAlphaComponent(0.1)
        }
        switch textAlignment {
        case .left:
            textField.textAlignment = .left
        case .center:
            textField.textAlignment = .center
        case .right:
            textField.textAlignment = .right
        }
        
        textField.delegate = context.coordinator
        let hostingVC: UIHostingController<Toolbar> = UIHostingController(rootView: toolbar(), ignoreSafeArea: true)
        hostingVC.sizingOptions = [.intrinsicContentSize]
        textField.inputAccessoryView = hostingVC.view
     
        textField.inputAccessoryView?.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
        if (uiView.text.isEmpty) {
            uiView.addSubview(placeHolderLabel)
            placeHolderLabel.constrainBottom(in: uiView)
        } else {
            uiView.removeLabels(with: placeholder)
        }
        
        if (textColorSelected) {
            DispatchQueue.main.async {
                uiView.textColor = UIColor(editorModel.textColor)
                textColorSelected = false
            }
        }
        
        if (textFontSelected) {
            DispatchQueue.main.async {
                uiView.font = UIFont(name: editorModel.textFontTitle, size: textSize)
                textFontSelected = false
            }
        }
        
        DispatchQueue.main.async {
            switch editorModel.textAlignment {
            case .left:
                uiView.textAlignment = .left
            case .center:
                uiView.textAlignment = .center
            case .right:
                uiView.textAlignment = .right
            }
        }
        
        Self.recalculateHeight(view: uiView, result: $calculatedHeight, textSize: $textSize)
        
    }
    
    static func recalculateHeight(view: UIView, result: Binding<CGFloat>, textSize: Binding<CGFloat>) {
        let newSize: CGSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if (newSize.height != result.wrappedValue) {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height
            }
        }
    }
    
    static func createUILabel(_ text: String, color: UIColor, textSize: CGFloat) -> UILabel {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: textSize)
        label.text = text
        label.textColor = color
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var contentView: CustomTextField
        var calculateHeight: Binding<CGFloat>
        var cursorPositionX: Binding<CGFloat>
        var cursorPositionY: Binding<CGFloat>
        var text: Binding<String>
        var textSize: Binding<CGFloat>
        var placeHolder: String
        var tempCursorPosition: Binding<CGFloat>
        var lineList: Binding<[EditorDataBaseModel]>
        var isTitle: Bool
        var lineid: String
        var removedId: Binding<Int>
        var lineType: Binding<listType>
        var returnedLineId: Binding<String?>
        var rowEdgeInsets: Binding<EdgeInsets>
        var isPopupEditor: Binding<Bool>
        var isIncreaseIndent: Binding<Bool>
        var isDecreaseIndent: Binding<Bool>
        
        init(_ contentView: CustomTextField, height: Binding<CGFloat>, cursorPositionX: Binding<CGFloat>, cursorPositionY: Binding<CGFloat>, text: Binding<String>, textSize: Binding<CGFloat>, placeHolder: String, tempCursorPosition: Binding<CGFloat>, lineList: Binding<[EditorDataBaseModel]>, isTitle: Bool, lineid: String, removedId: Binding<Int>, linetype: Binding<listType>, returnedLineId: Binding<String?>, rowEdgeInsets: Binding<EdgeInsets>, isPopupEditor: Binding<Bool>, isIncreaseIndent: Binding<Bool>, isDecreaseIndent: Binding<Bool>) {
            self.contentView = contentView
            self.calculateHeight = height
            self.cursorPositionX = cursorPositionX
            self.cursorPositionY = cursorPositionY
            self.text = text
            self.textSize = textSize
            self.placeHolder = placeHolder
            self.tempCursorPosition = tempCursorPosition
            self.lineList = lineList
            self.isTitle = isTitle
            self.lineid = lineid
            self.removedId = removedId
            self.lineType = linetype
            self.returnedLineId = returnedLineId
            self.rowEdgeInsets = rowEdgeInsets
            self.isPopupEditor = isPopupEditor
            self.isIncreaseIndent = isIncreaseIndent
            self.isDecreaseIndent = isDecreaseIndent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let endPosition: UITextPosition = textView.endOfDocument
            if let secondaryText: String = textView.text {
                let cursorPositionX: CGFloat = textView.caretRect(for: endPosition).origin.x
                let cursorPositionY: CGFloat = textView.caretRect(for: endPosition).origin.y
                DispatchQueue.main.async {
                    self.cursorPositionY.wrappedValue = cursorPositionY
                    if (self.placeHolder != secondaryText) {
                            self.text.wrappedValue = secondaryText
                        if (cursorPositionX + 290 < textView.bounds.width) {
                            self.cursorPositionX.wrappedValue = cursorPositionX
                            if (self.tempCursorPosition.wrappedValue < cursorPositionX) {
                                self.tempCursorPosition.wrappedValue = cursorPositionX
                            }
                        } else {
                            self.cursorPositionX.wrappedValue = self.tempCursorPosition.wrappedValue
                        }
                    }
                }
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
            // character deleted
            if (textView.text.isEmpty && !isTitle && text == "") {
                DispatchQueue.main.async {
                    if let index: Int = self.lineList.firstIndex(where: {$0.id.uuidString == self.lineid }) {
                        if self.lineList.wrappedValue[index].listType != .normal {
                            self.lineType.wrappedValue = .normal
                        } else {
                            // when indented
                            if self.rowEdgeInsets.wrappedValue.leading > 20 {
                                self.rowEdgeInsets.wrappedValue.leading -= 15
                                self.lineList.wrappedValue[index].lineEdgeInsets.leading -= 15
                                return
                            }
                            if self.rowEdgeInsets.wrappedValue.leading == 20 {
                                if (index > 0) {
                                    self.removedId.wrappedValue = index
                                }
                            }
                        }
                        if self.lineList.wrappedValue[index].textAlignment == .center {
                            textView.textAlignment = .left
                            self.lineList.wrappedValue[index].textAlignment = .left
                            self.contentView.editorModel.textAlignment = .left
                        }
                    }
                }
                return false
            }
            
            if (text == "\n" && !isTitle) {
                DispatchQueue.main.async {
                    self.isPopupEditor.wrappedValue = false
                    if let index: Int = self.lineList.wrappedValue.firstIndex(where: {$0.id.uuidString == self.lineid} ) {
                        let edgeInsets: EdgeInsets = self.lineList.wrappedValue[index].lineEdgeInsets
                        var textalignment: textAlignment = self.lineList.wrappedValue[index].textAlignment
                        if textalignment == .center {
                            textalignment = .left
                        }
                        switch self.lineType.wrappedValue {
                        case .task:
                            self.lineList.wrappedValue.insert(.init(listType: .task, lineEdgeInsets: edgeInsets, textAlignment: textalignment), at: index+1)
                        case .folding:
                            self.lineList.wrappedValue.insert(.init(listType: .folding, lineEdgeInsets: edgeInsets, textAlignment: textalignment), at: index+1)
                        case .bullet:
                            self.lineList.wrappedValue.insert(.init(listType: .bullet, lineEdgeInsets: edgeInsets, textAlignment: textalignment), at: index+1)
                        case .numbers:
                            let currentLineNumber: Int = self.lineList.wrappedValue[index].lineNumber
                            self.lineList.wrappedValue.insert(.init(listType: .numbers, lineNumber: currentLineNumber + 1, lineEdgeInsets: edgeInsets, textAlignment: textalignment), at: index+1)
                            self.chaneLineNumber(targetIndex: index)
                        case .normal:
                            self.lineList.wrappedValue.insert(.init(listType: .normal, textAlignment: textalignment), at: index+1)
                        case .block:
                            self.lineList.wrappedValue.insert(.init(listType: .block, textAlignment: textalignment), at: index+1)
                        case .line:
                            self.lineList.wrappedValue.insert(.init(listType: .normal, textAlignment: textalignment), at: index+1)
                        case .separate:
                            self.lineList.wrappedValue.insert(.init(listType: .normal, textAlignment: textalignment), at: index+1)
                        }
                        self.returnedLineId.wrappedValue = self.lineList.wrappedValue[index+1].id.uuidString
                        self.contentView.currentLIneId = self.lineList.wrappedValue[index+1].id.uuidString
                        
                    }
                }
                return false
            }
            return true
        }
        
        func chaneLineNumber(targetIndex: Int) {
            let targetLineEdgeInsets: EdgeInsets = self.lineList.wrappedValue[targetIndex].lineEdgeInsets
            let lineListSize: Int = self.lineList.wrappedValue.count
            if targetIndex+1 < lineListSize-1 {
                for index in targetIndex+2 ..< lineListSize {
                    let Line: EditorDataBaseModel = self.lineList.wrappedValue[index]
                    if targetLineEdgeInsets.leading == 20 {
                        if targetLineEdgeInsets.leading == Line.lineEdgeInsets.leading {
                            self.lineList.wrappedValue[index].lineNumber += 1
                        }
                    }
                }
            }
        }
    }
}

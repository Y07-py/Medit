//
//  ChatRoomView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/26.
//

import SwiftUI
import Combine

struct ChatRoomView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            header
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 20) {
                        ForEach(self.firebaseAuthView.currentChatRoom?.message ?? [], id: \.self) { message in
                            if message.id == self.firebaseAuthView.currentUser?.uid {
                                mymessageCard(message: message)
                            } else {
                                messageCard(message: message)
                            }
                        }
                    }
                }
            }
            Spacer()
            ChatRoomTextFieldView()
                .zIndex(10)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    @ViewBuilder
    var header: some View {
        HStack(alignment: .center) {
            Button(action: {
                self.firebaseAuthView.currentChatRoom = nil
                self.routeView.pop(1)
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black.opacity(0.8))
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func messageCard(message: ChatGroupMessage) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if let icon: UIImage = message.icon {
                    Image(uiImage: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 45))
                } else {
                    Circle()
                        .frame(width: 45, height: 45)
                        .foregroundStyle(.gray.opacity(0.4))
                }
                Text(message.username)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.gray.opacity(0.8))
                Spacer()
            }
            Text(message.message ?? "")
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(.black.opacity(0.8))
                .padding(.leading, 50)
        }
    }
    
    @ViewBuilder
    func mymessageCard(message: ChatGroupMessage) -> some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .center) {
                Spacer()
                Text(message.username)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.gray.opacity(0.8))
                if let icon: UIImage = message.icon {
                    Image(uiImage: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 45))
                } else {
                    Circle()
                        .frame(width: 45, height: 45)
                        .foregroundStyle(.gray.opacity(0.4))
                }
            }
            Text(message.message ?? "")
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(.black.opacity(0.8))
                .padding(.trailing, 50)
        }
    }
}

fileprivate struct ChatRoomTextFieldView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var text: String = ""
    @State private var textViewHeight: CGFloat = 40
    @FocusState private var focusRemainder: Bool
 
    var body: some View {
        HStack(alignment: .center) {
            ChatRoomTextField(placeholder: "メッセージを入力。", text: $text, textViewHeight: $textViewHeight) {
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.8))
                    HStack(alignment: .center) {
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up.on.square")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black.opacity(0.8))
                        }
                        Spacer()
                        Button(action: {
                            self.focusRemainder = false
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black.opacity(0.8))
                        }
                    }
                    .padding(10)
                }
            }
            .frame(height: textViewHeight)
            .focused($focusRemainder)
            .modifier(DeleteAllCharacter(text: $text, focusremainder: _focusRemainder))
        }
        .padding(5)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.8), lineWidth: 1)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct DeleteAllCharacter: ViewModifier {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @Binding var text: String
    @FocusState var focusremainder: Bool
    
    func body(content: Content) -> some View {
        HStack(alignment: .center, spacing: 10) {
            content
            Button(action: {
                self.focusremainder = false
                if !text.isEmpty {
                    Task {
                        try await self.firebaseAuthView.sendMessage(message: self.text)
                        self.text = ""
                    }
                }
            }) {
                Image(systemName: "paperplane")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.init(hex: "337357"))
            }
            .padding(.trailing, 10)
        }
    }
}

fileprivate struct ChatRoomTextField<ToolBar: View>: UIViewRepresentable {
    @Binding var text: String
    @Binding var textViewHeight: CGFloat
    
    let toolbar: () -> ToolBar
    let placeholder: UILabel
    
    init(placeholder: String, text: Binding<String>, textViewHeight: Binding<CGFloat>, @ViewBuilder toolbar: @escaping () -> ToolBar) {
        self.placeholder = Self.createUILabel(title: placeholder, textSize: 18)
        self._text = text
        self._textViewHeight = textViewHeight
        self.toolbar = toolbar
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(context: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView: UITextView = UITextView(frame: .zero)
        textView.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: textViewHeight))
        textView.text = ""
        textView.font = .systemFont(ofSize: 18)
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.isSelectable = false
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = true
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.addSubview(placeholder)
        
        let hostingVC: UIHostingController = UIHostingController(rootView: toolbar(), ignoreSafeArea: true)
        hostingVC.sizingOptions = [.intrinsicContentSize]
        textView.inputAccessoryView = hostingVC.view
        textView.inputAccessoryView?.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
        if uiView.text.isEmpty {
            uiView.addSubview(placeholder)
            placeholder.constrainBottom(in: uiView)
        } else {
            uiView.removeLabels(with: placeholder.text ?? "")
        }
        
        Self.recalculateHeight(view: uiView, height: $textViewHeight)
    }
    
    static func recalculateHeight(view: UIView, height: Binding<CGFloat>) {
        let newSize: CGSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height != height.wrappedValue {
            DispatchQueue.main.async {
                height.wrappedValue = newSize.height
            }
        }
    }
    
    static func createUILabel(title: String, textSize: CGFloat) -> UILabel {
        let uilabel: UILabel = UILabel(frame: .zero)
        uilabel.font = .systemFont(ofSize: textSize)
        uilabel.text = title
        uilabel.textColor = .lightGray
        uilabel.sizeToFit()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        return uilabel
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let context: ChatRoomTextField
        
        init(context: ChatRoomTextField) {
            self.context = context
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.context.text = textView.text
        }
    }
}



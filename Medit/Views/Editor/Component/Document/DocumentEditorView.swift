//
//  DocumentEditorView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/20.
//

import SwiftUI
import SDWebImageSwiftUI
import MCEmojiPicker

struct DocumentEditorView: View {
    @StateObject var editorModel: EditorViewModel = EditorViewModel()
    @StateObject var calendarModel: CalendarViewModel = CalendarViewModel()
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @EnvironmentObject var editorMasterCotroller: EditorMasterControllerViewModel
    @EnvironmentObject var editorController: EditorControllerViewModel
    @EnvironmentObject var documentRouteView: NavigationRouterViewModel<MediaRoute>
                                                                        
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var iskeyboardActive: Bool = false
    @State private var isPopupEditor: Bool = false
    @State private var textColorSelected: Bool = false
    @State private var textTitleSize: CGFloat = 23
    @State private var protrudingLineId: String? // <- This argument is used in editorView
    @State private var windowHeight: CGFloat = 0
    @State private var currentLindId: String? = UUID().uuidString
    @State private var ischangeEditorImage: Bool = false
    @State private var coverImage: UIImage? = nil
    @State private var isFolderActive: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var popupHeight: CGFloat = 180
    @State private var popupWidth: CGFloat = 270
    @State private var isemojiPickerActive: Bool = false
    @State private var emoji: String = ""
    @State private var isSaveAlert: Bool = false
    @State private var isdeadLineActive: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                VStack(alignment: .center, spacing: 0) {
                    HStack {
                        backBtn
                        Text("ドキュメント")
                            .font(.subheadline)
                            .foregroundStyle(.black.opacity(0.8))
                        Spacer()
                        settingBtn
                    }
                    .padding(.top, 40)
                    .frame(height: 80)
                    .padding(.horizontal, 20)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.2))
                    EditorView(isdeadLineActive: $isdeadLineActive, iskeyboardActive: $iskeyboardActive) {
                        // Header View
                        VStack(alignment: .leading, spacing: 15) {
                            VStack(alignment: .leading, spacing: 10) {
                                VStack(spacing: 0) {
                                    Group {
                                        if let coverImage: UIImage = self.coverImage {
                                            Image(uiImage: coverImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 210)
                                                .clipShape(Rectangle())
                                        } else {
                                            Image("document")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 210)
                                                .clipShape(Rectangle())
                                        }
                                    }
                                    .overlay {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    self.ischangeEditorImage.toggle()
                                                }) {
                                                    Text("イメージの変更")
                                                        .foregroundStyle(.gray)
                                                        .padding(5)
                                                        .font(.system(size: 13, weight: .semibold))
                                                        .background(.white)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .stroke(.gray.opacity(0.2), lineWidth: 1)
                                                        }
                                                }
                                            }
                                            .padding()
                                            Spacer()
                                        }
                                    }
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(.gray.opacity(0.2))
                                }
                            }
                            
                            Group {
                                HStack(alignment: .center, spacing: 0) {
                                    Group {
                                        if self.emoji.isEmpty {
                                            Button(action: {
                                                self.isemojiPickerActive.toggle()
                                            }) {
                                                HStack(alignment: .center) {
                                                    Image(systemName: "face.smiling")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundStyle(.gray.opacity(0.8))
                                                }
                                            }
                                        } else {
                                            HStack(alignment: .top) {
                                                Button(action: {
                                                    self.isemojiPickerActive.toggle()
                                                }) {
                                                    Text(self.emoji)
                                                        .font(.system(size: 60))
                                                }
                                                Button(action: {
                                                    self.emoji = ""
                                                }) {
                                                    Text("絵文字を削除")
                                                        .font(.system(size: 15, weight: .light))
                                                        .foregroundStyle(.gray.opacity(0.8))
                                                }
                                            }
                                        }
                                    }
                                    .emojiPicker(isPresented: $isemojiPickerActive, selectedEmoji: $emoji)
                                    .padding(.leading, 15)
                                    EditorTextView(titleKey: "タイトルを入力", font: .title, paddingLeading: 15, lineId: nil, isTitle: true, textAlignment: .left, text: $editorModel.text, textSize: $textTitleSize, protrudingLineId: $protrudingLineId, windowHeight: $windowHeight, currentLineId: $currentLindId, isPopupEditor: $isPopupEditor, iskeyboardActive: $iskeyboardActive) {
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
                                    }
                                    .environmentObject(editorModel)
                                }
                            }
                            .popover(isPresented: $isPopupEditor) {
                                EditorPopupView(popupHeight: $popupHeight, popupWidth: $popupWidth, isheaderPopup: true, lineid: nil)
                                    .environmentObject(editorModel)
                                    .environmentObject(routeView)
                                    .environmentObject(editorController)
                                    .presentationCompactAdaptation(.popover)
                            }
                            
                            Group {
                                HStack(alignment: .center) {
                                    Group {
                                        Group {
                                            Image(systemName: "link.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                            Text("リンク:")
                                        }
                                        .foregroundStyle(.gray)
                                    }
                                    .font(.subheadline)
                                }
                                
                                HStack(alignment: .center) {
                                    Group {
                                        Group {
                                            Image(systemName: "person")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                            Text("作成者:")
                                        }
                                        .foregroundStyle(.gray)
                                    }
                                    .font(.subheadline)
                                }
                                
                                HStack(alignment: .center) {
                                    Group {
                                        Group {
                                            Image(systemName: "pencil.line")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                            Text("作成日:")
                                        }
                                        .foregroundStyle(.gray)
                                        Text(convertDatetoString(.init()))
                                    }
                                    .font(.subheadline)
                                }
                            }
                            .padding(.leading, 15)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                    }
                    .environmentObject(editorController)
                    .environmentObject(routeView)
                }
                
            }
            .popover(isPresented: $ischangeEditorImage) {
                EditorImageSearchView(coverImage: $coverImage)
                    .presentationCompactAdaptation(.fullScreenCover)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar(.hidden)
    }
    
    @ViewBuilder
    var backBtn: some View {
        Button(action: {
            self.isSaveAlert.toggle()
        }) {
            Image(systemName: "chevron.backward")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.black)
        }
        .buttonStyle(.plain)
        .alert(isPresented: $isSaveAlert) {
            Alert(title: Text("保存しますか？"),
                  primaryButton: Alert.Button.default(Text("はい"), action: {
                self.routeView.pop(1)
            }), secondaryButton: Alert.Button.cancel(Text("いいえ"), action: {
                self.routeView.pop(1)
            }))
        }
    }
    
    @ViewBuilder
    var settingBtn: some View {
        HStack(alignment: .bottom, spacing: 20) {
            Button(action:{}) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
            Button(action: {}) {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
        }
    }

    func convertDatetoString(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年M月d日 H:mm"
        return dateFormatter.string(from: date)
    }
}

fileprivate struct EditorImageSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedViewNumber: Int = 0
    @State private var selectedImage: UIImage? = nil
    @Namespace var namespace
    
    @Binding var coverImage: UIImage?
    
    var body: some View {
        VStack {
            Header
            MenuBar
            TabView(selection: $selectedViewNumber) {
                UploadView(selectedImage: $selectedImage)
                    .tag(0)
                URLLinkView(selectedImage: $selectedImage, selectedViewNumber: $selectedViewNumber)
                    .tag(1)
                SearchFromUnsplashView(selectedImage: $selectedImage)
                    .tag(2)
            }
            .animation(.easeInOut, value: selectedViewNumber)
            .onChange(of: selectedViewNumber) { _, newValue in
                withAnimation {
                    self.selectedImage = nil
                }
            }
            .onChange(of: self.selectedImage) {
                print("Hello")
            }
        }
    }
    
    @ViewBuilder
    var Header: some View {
        HStack {
            Button(action: {
                self.dismiss()
            }) {
                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black.opacity(0.8))
            }
            Spacer()
            if let selectedImage: UIImage = self.selectedImage {
                Button(action: {
                    self.coverImage = selectedImage
                    self.dismiss()
                }) {
                    Text("決定")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: 30)
        .padding()
    }
    
    @ViewBuilder
    var MenuBar: some View {
        HStack {
            MenuItem(title: "アップロード", number: 0, namespace: namespace, systemName: "square.and.arrow.up")
            MenuItem(title: "URLリンク", number: 1, namespace: namespace, systemName: "link.circle")
            MenuItem(title: "Unsplash", number: 2, namespace: namespace, systemName: "")
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: 30)
    }
    
    @ViewBuilder
    func MenuItem(title: String, number: Int, namespace: Namespace.ID, systemName: String) -> some View {
        Button(action: {
            withAnimation {
                self.selectedViewNumber = number
            }
        }) {
            VStack {
                HStack {
                    if systemName.isEmpty {
                        Image("unsplash")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 15)
                            .clipShape(Rectangle())
                    } else {
                        Image(systemName: systemName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.black)
                    }
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.black)
                }
                if self.selectedViewNumber == number {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black)
                        .matchedGeometryEffect(id: "namespace", in: namespace)
                } else {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.clear)
                }
            }
        }
    }
}

fileprivate struct UploadView: View {
    @State private var isUpload: Bool = false
    @State private var isphotoViewActive: Bool = false
    @State private var iscameraViewActive: Bool = false
    @State private var isFoldViewActive: Bool = false
    @State private var isGoogleDriveActive: Bool = false
    
    @State private var fileURL: URL? = nil
    
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack {
                Button(action: {
                    withAnimation {
                        self.isUpload.toggle()
                    }
                }) {
                    VStack(spacing: 10) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray.opacity(0.8))
                        HStack(spacing: 10) {
                            Image(systemName: "tray.and.arrow.up.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.gray.opacity(0.8))
                            Text("ファイルのアップロード")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.black.opacity(0.8))
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray.opacity(0.8))
                    }
                }
                .buttonStyle(.plain)
                Text("ファイルあたりの最大サイズは5MBです。")
                    .font(.caption)
                    .foregroundStyle(.gray.opacity(0.8))
                    .padding()
            }
            .popover(isPresented: $isUpload) {
                uploadTypeAlert
                    .presentationCompactAdaptation(.popover)
            }
            if let image: UIImage = self.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $isphotoViewActive) {
            PhotoView(selectedImage: $selectedImage, isrouteView: false)
        }
        .fullScreenCover(isPresented: $iscameraViewActive) {
            CameraView(selectedImage: $selectedImage, isrouteView: false)
        }
        .fullScreenCover(isPresented: $isFoldViewActive) {
            DocumentPickerView(selectedImage: $selectedImage, isrouteView: false)
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    var uploadTypeAlert: some View {
        VStack(alignment: .leading) {
            uploadTypeButton(systemName: "photo", title: "写真ライブラリ", isActive: $isphotoViewActive)
                .padding(.top, 5)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.8))
            uploadTypeButton(systemName: "camera", title: "カメラ", isActive: $iscameraViewActive)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.8))
            uploadTypeButton(systemName: "folder", title: "フォルダ", isActive: $isFoldViewActive)
                .padding(.bottom, 5)
        }
        .frame(width: 230)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    func uploadTypeButton(systemName: String, title: String, isActive: Binding<Bool>) -> some View {
        Button(action: {
            withAnimation {
                isActive.wrappedValue.toggle()
                self.isUpload = false
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black.opacity(0.8))
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

fileprivate struct URLLinkView: View {
    @State private var url: String = ""
    @State private var imageURL: String = ""
    @State private var isFailure: Bool = true
    
    @Binding var selectedImage: UIImage?
    @Binding var selectedViewNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("画像リンクを貼り付ける...", text: $url)
                .padding()
                .overlay {
                    Rectangle()
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
                .onSubmit {
                    if !self.url.isEmpty {
                        self.imageURL = self.url
                        self.url = ""
                    }
                }
                .submitLabel(.search)
                
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    WebImage(url: URL(string: imageURL))
                        .onSuccess(perform: { image, data, cacheType in
                            self.selectedImage = image.withRenderingMode(.automatic)
                            self.isFailure = false
                        })
                        .onFailure(perform: { error in
                            self.isFailure = true
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                
                  
                    
                    Text("Web上の画像をカバー画像にできます。")
                        .font(.caption)
                        .foregroundStyle(.gray.opacity(0.8))
                        .padding(.leading)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onChange(of: self.selectedViewNumber) { oldValue, newValue in
            self.imageURL = ""
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
    }
}

fileprivate struct SearchFromUnsplashView: View {
    @Binding var selectedImage: UIImage?
    var body: some View {
        VStack {
            UnsplashView(selectedImage: $selectedImage, isrouteView: false)
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
    }
}




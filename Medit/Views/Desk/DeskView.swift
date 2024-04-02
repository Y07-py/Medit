//
//  DeskView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/03.
//

import SwiftUI

enum FileStatus: Hashable {
    case document
    case task
    case memo
}

struct DeskView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    
    @State private var ismenuView: Bool = false
    @State private var sidemenuOffset: CGFloat = .zero
    @State private var fileStatus: FileStatus = .document
    
    var body: some View {
        ZStack {
            DeskMenuView(folderStatus: $fileStatus)
            ZStack {
                VStack(spacing: 0) {
                    DeskViewHeader
                    DeskViewSeachHeader
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.2))
                        .padding(.vertical, 30)
                    
                    TabView(selection: $fileStatus) {
                        
                        // Document Folder View
                        DeskFolderView {
                            HStack(alignment: .center, spacing: 20) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "doc")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.init(hex: "#6C00FF"))
                                    Text("ドキュメント")
                                        .font(.headline)
                                        .foregroundStyle(.black.opacity(0.8))
                                }
                                .padding(10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.init(hex: "#6C00FF").opacity(0.2))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.init(hex: "#6C00FF").opacity(0.5), lineWidth: 1)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .tag(FileStatus.document)
                        
                        // Task Folder View
                        DeskFolderView {
                            HStack(alignment: .center, spacing: 20) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "pencil.and.list.clipboard")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.init(hex: "#3C79F5"))
                                    Text("タスク")
                                        .font(.headline)
                                        .foregroundStyle(.black.opacity(0.8))
                                }
                                .padding(10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.init(hex: "#3C79F5").opacity(0.2))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.init(hex: "#3C79F5").opacity(0.5), lineWidth: 1)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .tag(FileStatus.task)
                        
                        // Memo Folder View
                        DeskFolderView {
                            HStack(alignment: .center, spacing: 20) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "pencil.line")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.init(hex: "#2DCDDF"))
                                    Text("メモ")
                                        .font(.headline)
                                        .foregroundStyle(.black.opacity(0.8))
                                }
                                .padding(10)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(Color.init(hex: "#2DCDDF").opacity(0.2))
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.init(hex: "#2DCDDF").opacity(0.5), lineWidth: 1)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .tag(FileStatus.memo)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Rectangle()
                    .foregroundStyle(.black.opacity(0.2))
                    .ignoresSafeArea()
                    .opacity(ismenuView ? 1.0 : .zero)
            }
            .background(.white)
            .offset(x: sidemenuOffset)
            
        }
        .toolbar(.hidden)
        .animation(.easeInOut, value: ismenuView)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    if ismenuView {
                        if value.location.x <= UIWindow().bounds.width * (3/4) {
                            self.sidemenuOffset = value.location.x
                        }
                    }
                })
                .onEnded({ value in
                    if value.location.x < UIWindow().bounds.width * (3/4) {
                        withAnimation {
                            self.sidemenuOffset = .zero
                            self.ismenuView = false
                        }
                    } else {
                        withAnimation {
                            self.sidemenuOffset = UIWindow().bounds.width * (3/4)
                            self.ismenuView = true
                        }
                    }
                })
        )
    }
    
    @ViewBuilder
    private var DeskViewHeader: some View {
        HStack(alignment: .center, spacing: 10) {
            Button(action: {
                withAnimation {
                    if !ismenuView {
                        self.sidemenuOffset = UIWindow().bounds.width * (3/4)
                    }
                    self.ismenuView.toggle()
                }
            }) {
                Image(systemName: "text.line.first.and.arrowtriangle.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding()
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding()
            
        }
    }
    
    @ViewBuilder
    private var DeskViewSeachHeader: some View {
        Button(action: {}) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding()
                Text("\(self.firebaseAuthView.username)のデスクで検索")
                    .font(.callout)
                    .padding()
                Spacer()
            }
            .background(.white)
            .frame(width: UIWindow().bounds.width - 40, height: 40)
            .foregroundStyle(.gray.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        
        
    }
}


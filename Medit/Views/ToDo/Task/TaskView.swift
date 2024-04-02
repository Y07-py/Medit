//
//  TaskView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/25.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    
    @State private var searchtext: String = ""
    @State private var currentStatusBar: Int = 0
    @State private var searchBarTapped: Bool = false
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            if !searchBarTapped {
                VStack(spacing: 0) {
                    TaskHeaderView(searchtext: $searchtext, currentStatusBar: $currentStatusBar, searchBarTapped: $searchBarTapped, namespace: namespace)
                        .blur(radius: searchBarTapped ? 10 : 0)
                    
                    TabView(selection: $currentStatusBar) {
                        TodayAllTaskListView()
                            .tag(0)
                        TodayWaitingAllTaskListView()
                            .tag(1)
                        TodayDoingAllTaskListView()
                            .tag(2)
                        TodayDoneAllTaskListView()
                            .tag(3)
                    }
                    .environmentObject(routeView)
                    .environmentObject(editorMasterController)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            } else {
                TaskExpandedSearchView(searchText: $searchtext, searchBarTapped: $searchBarTapped, namespace: namespace)
            }
        }
    }
}

fileprivate struct TaskCardView: View {
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    @EnvironmentObject var calendarModel: CalendarViewModel
    @State private var offsetx: CGFloat = .zero
    @State private var opacity: CGFloat = 1.0
    @State private var isDelete: Bool = false
    
    let task: EditorTaskModel
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                Button(action: {}) {
                    Color
                        .init(hex: "5800FF")
                }
                .overlay {
                    HStack {
                        Image(systemName: "play")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                            .padding(.leading, 20)
                        Spacer()
                    }
                }
                
                Button(action: {
                    withAnimation(.linear) {
                        self.offsetx = .zero
                        self.isDelete.toggle()
                    }
                    withAnimation(.linear.delay(0.3)) {
                        self.opacity = .zero
                    }
                    withAnimation(.linear.delay(1.0))  {
                        self.offsetx = -UIWindow().bounds.width
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.8) {
                        self.editorMasterController.deleteTaskData(entity: task)
                        self.calendarModel.reloadTimelineTaskData(date: task.startDate ?? .now)
                    }
                    
                }) {
                    Color
                        .red
                }
                .overlay {
                    HStack {
                        Spacer()
                        Image(systemName: "trash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                            .padding(.trailing, 20)
                    }
                }
            }
            .opacity(self.opacity)
            .frame(width: UIWindow().bounds.width - 70)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.top, 30)
            
            VStack(alignment: .leading, spacing: 10) {
                Text((task.startDate?.formatted(date: .omitted, time: .shortened) ?? "") + " 開始予定")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                HStack(alignment: .top, spacing: 10) {
                    taskImageView(imageData: task.coverImage)
                        .padding([.vertical,.leading])
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 5) {
                            Image(systemName: "book.pages")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.gray)
                            Text(task.title ?? "")
                                .font(.headline)
                                .foregroundStyle(.black.opacity(0.8))
                                .padding(.vertical)
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray.opacity(0.8))
                            .padding(.trailing)
                        HStack {
                            Text("終了時間: 12時30分")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            Spacer()
                            statusView(color: "#0096FF", status: "待機中")
                                .padding(.horizontal)
                        }
                        .padding(.top, 5)
                    }
                }
                .background(.white)
                .frame(width: UIWindow().bounds.width - 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.08), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.08), radius: 5, x:5, y:5)
                .shadow(color: .black.opacity(0.08), radius: 5, x:-5, y:-5)
            }
            .offset(x: self.offsetx)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.onChanged(value: value)
                    })
                    .onEnded({ value in
                        self.onEnded(value: value)
                    })
            )
        }
    }
    
    @ViewBuilder
    func statusView(color: String, status: String) -> some View {
        HStack(alignment: .center, spacing: 5) {
            Circle()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color(hex: color))
            Text(status)
                .font(.subheadline)
        }
    }
    
    @ViewBuilder
    func taskImageView(imageData: Data?) -> some View {
        if let imageData: Data = imageData {
            if let image: UIImage = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.08), lineWidth: 1)
                    }
            }
        } else {
            Image("task")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.8), lineWidth: 1)
                }
        }
    }
    
    func onChanged(value: DragGesture.Value) {
        if (self.offsetx < 0 && self.offsetx > -80) {
            if value.translation.width > 0 {
                withAnimation {
                    self.offsetx = -30
                }
                return
            }
        }
        if (self.offsetx > 0 && self.offsetx < 80) {
            if value.translation.width < 0 {
                withAnimation {
                    self.offsetx = 30
                }
                return
            }
        }
        if (value.translation.width > -80 && value.translation.width < 0) {
            self.offsetx = value.translation.width
        }
        if (value.translation.width < 80 && value.translation.width > 0) {
            self.offsetx = value.translation.width
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation {
            if self.offsetx < -30 {
                self.offsetx = -70
            } else if self.offsetx > 30 {
                self.offsetx = 70
            } else {
                self.offsetx = .zero
            }
        }
    }
}

fileprivate struct TodayAllTaskListView: View {
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @EnvironmentObject var editorMasterController: EditorMasterControllerViewModel
    
    var body: some View {
        ScrollViewReader { scrollreader in
            ScrollView(.vertical) {
                Group {
                    if self.editorMasterController.tasklists.isEmpty {
                        taskListsbackground
                    }
                }
                .offset(y: 150)
                VStack(spacing: 0) {
                    ForEach(self.editorMasterController.tasklists, id: \.self) { task in
                        HStack {
                            VStack(spacing: 0) {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(Color(hex: "13005A"))
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.leading, 10)
                            VStack {
                                TaskCardView(task: task)
                                    .onTapGesture {
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        editorMasterController.selectedTaskModel = task
                                        routeView.push(.TaskEditor)
                                    }
                                    .environmentObject(editorMasterController)
                                Spacer()
                                    .frame(height: 30)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .frame(width: UIWindow().bounds.width)
                .padding(.top, 20)
                Spacer()
                    .frame(height: 100)
            }
        }
    }
    
    @ViewBuilder
    var taskListsbackground: some View {
        VStack(alignment: .center) {
            Image(systemName: "book.pages")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray.opacity(0.3))
            Text("設定されたタスクはありません。")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.gray.opacity(0.3))
        }
        .padding()
    }
}

fileprivate struct TodayWaitingAllTaskListView: View {
    var body: some View {
        Text("Waiting")
    }
}

fileprivate struct TodayDoingAllTaskListView: View {
    var body: some View {
        Text("Doing")
    }
}

fileprivate struct TodayDoneAllTaskListView: View {
    var body: some View {
        Text("Done")
    }
}

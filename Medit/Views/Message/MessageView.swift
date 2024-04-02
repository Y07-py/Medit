//
//  SearchView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/03.
//

import SwiftUI

struct MessageView: View {
    @EnvironmentObject var firebaseAuthView: FirebaseAuthControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<MessageRoute>
    @EnvironmentObject var mainRouteView: NavigationRouterViewModel<Route>
    
    @State private var searchText: String = ""
    @State private var isTalkto: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            header
            messageSearchHeader
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(self.firebaseAuthView.chatgroups), id: \.key) { key, room in
                        Button(action: {
                            self.firebaseAuthView.currentChatRoom = room
                            self.mainRouteView.push(.ChatRoom)
                        }) {
                            HStack(alignment: .center, spacing: 10) {
                                if let uiimage: UIImage = room.coverimage {
                                    Image(uiImage: uiimage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 40))
                                } else {
                                    Image(systemName: "person.2.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 40))
                                        .foregroundStyle(.gray.opacity(0.8))
                                }
                                Text(room.groupname)
                                    .font(.title3)
                                    .foregroundStyle(.black.opacity(0.8))
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .popover(isPresented: $isTalkto) {
            SelectTalktoView()
        }
        
    }
    
    @ViewBuilder
    var header: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(action: {
                withAnimation {
                    self.isTalkto.toggle()
                }
            }) {
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .contentShape(Rectangle())
            
            Button(action: {
                self.routeView.push(.createchatgroup)
            }) {
                Image(systemName: "plus.message")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black.opacity(0.8))
            }
            .contentShape(Rectangle())
            
            Spacer()
            
            currentUsericon
        }
    }
    
    @ViewBuilder
    var currentUsericon: some View {
        if let uiimage: UIImage = self.firebaseAuthView.usericon {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        } else {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(.gray)
        }
    }
    
    @ViewBuilder
    var messageSearchHeader: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundStyle(.gray.opacity(0.8))
            TextField("グループまたはユーザーの検索", text: $searchText)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        }
    }
}


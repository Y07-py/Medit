//
//  FirebaseAuthControllerViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/03/12.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage
import Combine
import OrderedCollections

class FirebaseAuthControllerViewModel: ObservableObject {
    @Published var isSignedin: Bool? = nil
    @Published var currentUser: FirebaseAuth.User? = nil
    @Published var issignInCompleted: Bool = false
    @Published var isAllCompleted: Bool = false
    @Published var username: String = ""
    @Published var profile: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userCoverImage: UIImage? = nil
    @Published var usericon: UIImage? = nil
    @Published var talkingUsers: [FirebaseModel] = []
    @Published var users: OrderedDictionary<String, FirebaseModel> = [:]
    @Published var addedusers: OrderedDictionary<String, FirebaseModel> = [:]
    @Published var chatGroupCoverImage: UIImage? = nil
    @Published var chatgroups:OrderedDictionary<String, ChatGroup> = [:]
    @Published var groupName: String = ""
    @Published var currentChatRoom: ChatGroup? = nil
    
    private var subscribers: Set<AnyCancellable> = []
                            
    init() {
        DispatchQueue.main.async {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user: FirebaseAuth.User = user {
                    self.currentUser = user
                    self.isSignedin = true
                    print("認証状態を変更しました。現在サインインしています。")
                } else {
                    self.isSignedin = false
                    print("認証状態を変更しました。現在サインアウトしています。")
                }
            }
        }
        
        Task {
            let dispatchGroup: DispatchGroup = DispatchGroup()
            do {
                let collections: QuerySnapshot = try await Firestore.firestore().collection("chatgroup").getDocuments()
                let usercollections: CollectionReference = Firestore.firestore().collection("users")
                let storageRef: StorageReference = Storage.storage().reference()
                for collection in collections.documents {
                    
                    var users: [ChatUser] = []
                    var messages: [ChatGroupMessage] = []
                    let chatData: [String: Any] = collection.data()
                    
                    for user in chatData["users"] as! [String] {
                        let userdata: [String: Any] = try await usercollections.document(user).getDocument().data() ?? [:]
                        dispatchGroup.enter()
                        storageRef.child("images/\(user).jpg").getData(maxSize: 1*1024*1024, completion: { data, error in
                            if let error: Error = error {
                                fatalError(error.localizedDescription)
                            }
                            guard let iconData: Data = data else { return }
                            if let iconImage: UIImage = UIImage(data: iconData) {
                                users.append(.init(id: userdata["id"] as! String, username: userdata["username"] as! String, icon: iconImage))
                            }
                            dispatchGroup.leave()
                        }).resume()
                    }
                    
                    
                    let chatroom: CollectionReference = Firestore.firestore().collection("chatgroup").document(collection["id"] as! String).collection("messages")
                    let messagesQuery: QuerySnapshot = try await chatroom.getDocuments()
                    for message in messagesQuery.documents {
                        let messageData: [String: Any] = message.data()
                        let user: [String: Any] = try await usercollections.document(message["id"] as! String).getDocument().data() ?? [:]
                        dispatchGroup.enter()
                        storageRef.child("images/\(user["id"] as! String).jpg").getData(maxSize: 1*1024*1024) { data, error in
                            if let error: Error = error {
                                fatalError(error.localizedDescription)
                            }
                            guard let iconData: Data = data else { return }
                            if let iconImage: UIImage = UIImage(data: iconData) {
                                messages.append(.init(id: messageData["id"] as! String, username: user["username"] as! String, message: messageData["message"] as? String, icon: iconImage))
                            }
                            dispatchGroup.leave()
                        }.resume()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        storageRef.child("chatgroups/\(collection["id"] as! String).jpg").getData(maxSize: 1*1024*1024) { data, error in
                            if let error: Error = error {
                                fatalError(error.localizedDescription)
                            }
                            guard let coverData: Data = data else { return }
                            if let coverImage: UIImage = UIImage(data: coverData) {
                                self.chatgroups[collection["id"] as! String] = ChatGroup(id: collection["id"] as! String, groupname: collection["groupname"] as! String, users: users, message: messages, coverimage: coverImage)
                            }
                        }
                    }
                }
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
        Firestore.firestore().collection("chatgroup").addSnapshotListener { query, error in
            if let error: Error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        $isSignedin
            .receive(on: RunLoop.main)
            .sink { [weak self] bool in
                do {
                    guard let user: FirebaseAuth.User = self?.currentUser else { return }
                    guard let username: String = self?.username else { return }
                    if username.isEmpty {
                        try await self?.fetchUserDocument(user: user)
                    }
                } catch let error {
                    fatalError(error.localizedDescription)
                }
            }
            .store(in: &subscribers)
    }
    
    func regularCreateAccount(email: String, password: String, username: String, profile: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user: FirebaseUserModel = FirebaseUserModel(id: result.user.uid, username: username, email: email, password: password, profile: profile, chatgroup: [], chatroom: [], chatrequest: [], grouprequest: [])
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            self.uploadImagetoFirebase(image: self.usericon, currentPath: result.user.uid, mainPath: "images")
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func regularSignOut(completion: @escaping (Error?) -> Void) {
        let firebaseAuth: FirebaseAuth.Auth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.currentUser = nil
            print("Scccess sign out.")
            completion(nil)
        } catch let error as NSError {
            completion(error)
            fatalError(error.localizedDescription)
        }
    }
    
    func regularSignIn() async throws {
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchUserDocument(user: FirebaseAuth.User) async throws {
        do {
            guard let currentUser: FirebaseAuth.User = self.currentUser else { return }
            let userDocument = try await Firestore.firestore().collection("users").document(currentUser.uid).getDocument()
            let storageRef: StorageReference = Storage.storage().reference()
            let userIconRef: StorageReference = storageRef.child("images/\(user.uid).jpg")
            userIconRef.getData(maxSize: 1*1024*1024) { data, error in
                if let error: Error = error {
                    fatalError(error.localizedDescription)
                }
                guard let iconData: Data = data else { return }
                self.usericon = UIImage(data: iconData)
            }
            
            DispatchQueue.main.async {
                guard let userData: [String: Any] = userDocument.data() else { return }
                self.username = userData["username"] as! String
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func uploadImagetoFirebase(image: UIImage?, currentPath: String, mainPath: String) {
        let firebaseStorageRef: StorageReference = Storage.storage().reference()
        if let image: UIImage = image {
            guard let imageData: Data = image.jpegData(compressionQuality: 0.8) else { return }
            let fileRef: StorageReference = firebaseStorageRef.child("\(mainPath)/\(currentPath).jpg")
            fileRef.putData(imageData, metadata: nil) { metaData, error in
                if let error: Error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchUsersData() async throws {
        let firebaseStorageRef: StorageReference = Storage.storage().reference()
        do {
            let collections: QuerySnapshot = try await Firestore.firestore().collection("users").getDocuments()
            for collection in collections.documents {
                let userData: [String: Any] = collection.data()
                if self.currentUser?.uid == userData["id"] as? String { continue }
                var usericon: UIImage?
                firebaseStorageRef.child("images/\(userData["id"] as! String).jpg").getData(maxSize: 1*1024*1024) { data, error in
                    if let error: Error = error {
                        fatalError(error.localizedDescription)
                    }
                    guard let iconData: Data = data else { return }
                    usericon = UIImage(data: iconData)
                    let firebaseUserData: FirebaseModel = FirebaseModel(id: userData["id"] as! String, username: userData["username"] as! String, email: userData["email"] as! String, profile: userData["email"] as! String, coverImage: usericon)
                    DispatchQueue.main.async {
                        self.users[userData["id"] as! String] = firebaseUserData
                    }
                }
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func createChatGroup() async throws {
        let uuid: String = UUID().uuidString
        let fireStoreChatGoup: DocumentReference = Firestore.firestore().collection("chatgroup").document(uuid)
        let fireStoreUsers: CollectionReference = Firestore.firestore().collection("users")
        do {
            var chatGroupModel: FirebaseChatGroup = FirebaseChatGroup(id: uuid, groupname: self.groupName, users: [], messages: [])
            guard let userid: String = self.currentUser?.uid else { return }
            try await fireStoreUsers.document(userid).updateData([
                "chatgroup": FieldValue.arrayUnion([uuid])
            ])
            
            for user in self.addedusers.values {
                chatGroupModel.users.append(user.id)
                try await fireStoreUsers.document(user.id).updateData([
                    "chatgroup": FieldValue.arrayUnion([uuid])
                ])
            }
            
            let encodedChatModel: [String: Any] = try Firestore.Encoder().encode(chatGroupModel)
            try await fireStoreChatGoup.setData(encodedChatModel)
            self.uploadImagetoFirebase(image: self.chatGroupCoverImage, currentPath: uuid, mainPath: "chatgroups")
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func sendMessage(message: String) async throws {
        guard let roomid: String = self.currentChatRoom?.id else { return }
        let fireStoreChatRef: CollectionReference = Firestore.firestore().collection("chatgroup").document(roomid).collection("messages")
        guard let userid: String = self.currentUser?.uid else { return }
        do {
            let messageData: ChatMessage = ChatMessage(id: userid, message: message, imageData: nil)
            let encodedData: [String: Any] = try Firestore.Encoder().encode(messageData)
            try await fireStoreChatRef.document(UUID().uuidString).setData(encodedData)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

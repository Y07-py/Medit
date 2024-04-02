//
//  ActiveUserModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension ActiveUserModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveUserModel> {
        return NSFetchRequest<ActiveUserModel>(entityName: "ActiveUserModel")
    }

    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var profile: String?
    @NSManaged public var userImage: Data?
    @NSManaged public var friends: NSSet?
    @NSManaged public var user_document: EditorDocumentModel?
    @NSManaged public var user_memo: EditorMemoModel?
    @NSManaged public var user_task: EditorTaskModel?

}

// MARK: Generated accessors for friends
extension ActiveUserModel {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: ActiveUserModel)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: ActiveUserModel)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension ActiveUserModel : Identifiable {

}

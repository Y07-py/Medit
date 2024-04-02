//
//  EditorTaskModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension EditorTaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorTaskModel> {
        return NSFetchRequest<EditorTaskModel>(entityName: "EditorTaskModel")
    }

    @NSManaged public var coverImage: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endData: Date?
    @NSManaged public var isRepeat: Bool
    @NSManaged public var basemodels: NSSet?
    @NSManaged public var status: TaskStatusModel?
    @NSManaged public var urls: NSSet?
    @NSManaged public var user_task: ActiveUserModel?

}

// MARK: Generated accessors for basemodels
extension EditorTaskModel {

    @objc(addBasemodelsObject:)
    @NSManaged public func addToBasemodels(_ value: EditorBaseModel)

    @objc(removeBasemodelsObject:)
    @NSManaged public func removeFromBasemodels(_ value: EditorBaseModel)

    @objc(addBasemodels:)
    @NSManaged public func addToBasemodels(_ values: NSSet)

    @objc(removeBasemodels:)
    @NSManaged public func removeFromBasemodels(_ values: NSSet)

}

// MARK: Generated accessors for urls
extension EditorTaskModel {

    @objc(addUrlsObject:)
    @NSManaged public func addToUrls(_ value: EditorURL)

    @objc(removeUrlsObject:)
    @NSManaged public func removeFromUrls(_ value: EditorURL)

    @objc(addUrls:)
    @NSManaged public func addToUrls(_ values: NSSet)

    @objc(removeUrls:)
    @NSManaged public func removeFromUrls(_ values: NSSet)

}

extension EditorTaskModel : Identifiable {

}

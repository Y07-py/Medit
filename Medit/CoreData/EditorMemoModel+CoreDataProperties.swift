//
//  EditorMemoModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension EditorMemoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorMemoModel> {
        return NSFetchRequest<EditorMemoModel>(entityName: "EditorMemoModel")
    }

    @NSManaged public var coverImage: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var basemodels_memo: NSSet?
    @NSManaged public var usre_memo: ActiveUserModel?

}

// MARK: Generated accessors for basemodels_memo
extension EditorMemoModel {

    @objc(addBasemodels_memoObject:)
    @NSManaged public func addToBasemodels_memo(_ value: EditorBaseModel)

    @objc(removeBasemodels_memoObject:)
    @NSManaged public func removeFromBasemodels_memo(_ value: EditorBaseModel)

    @objc(addBasemodels_memo:)
    @NSManaged public func addToBasemodels_memo(_ values: NSSet)

    @objc(removeBasemodels_memo:)
    @NSManaged public func removeFromBasemodels_memo(_ values: NSSet)

}

extension EditorMemoModel : Identifiable {

}

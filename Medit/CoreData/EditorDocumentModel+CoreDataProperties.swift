//
//  EditorDocumentModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension EditorDocumentModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorDocumentModel> {
        return NSFetchRequest<EditorDocumentModel>(entityName: "EditorDocumentModel")
    }

    @NSManaged public var coverImage: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var basemodels_document: NSSet?
    @NSManaged public var user_document: ActiveUserModel?

}

// MARK: Generated accessors for basemodels_document
extension EditorDocumentModel {

    @objc(addBasemodels_documentObject:)
    @NSManaged public func addToBasemodels_document(_ value: EditorBaseModel)

    @objc(removeBasemodels_documentObject:)
    @NSManaged public func removeFromBasemodels_document(_ value: EditorBaseModel)

    @objc(addBasemodels_document:)
    @NSManaged public func addToBasemodels_document(_ values: NSSet)

    @objc(removeBasemodels_document:)
    @NSManaged public func removeFromBasemodels_document(_ values: NSSet)

}

extension EditorDocumentModel : Identifiable {

}

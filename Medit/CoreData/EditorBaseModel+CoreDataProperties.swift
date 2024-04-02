//
//  EditorBaseModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension EditorBaseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorBaseModel> {
        return NSFetchRequest<EditorBaseModel>(entityName: "EditorBaseModel")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var lineNumber: Int64
    @NSManaged public var listType: String?
    @NSManaged public var priority: Int64
    @NSManaged public var separateHeight: Double
    @NSManaged public var textAlignment: String?
    @NSManaged public var basemodels: EditorTaskModel?
    @NSManaged public var basemodels_document: EditorDocumentModel?
    @NSManaged public var basemodels_memo: EditorMemoModel?
    @NSManaged public var childdata: NSSet?
    @NSManaged public var edgeinsets: EditorEdgeInsets?
    @NSManaged public var mediadata: MediaDataModel?
    @NSManaged public var textmodel: TextDataModel?

}

// MARK: Generated accessors for childdata
extension EditorBaseModel {

    @objc(addChilddataObject:)
    @NSManaged public func addToChilddata(_ value: EditorBaseModel)

    @objc(removeChilddataObject:)
    @NSManaged public func removeFromChilddata(_ value: EditorBaseModel)

    @objc(addChilddata:)
    @NSManaged public func addToChilddata(_ values: NSSet)

    @objc(removeChilddata:)
    @NSManaged public func removeFromChilddata(_ values: NSSet)

}

extension EditorBaseModel : Identifiable {

}

//
//  TextDataModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension TextDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextDataModel> {
        return NSFetchRequest<TextDataModel>(entityName: "TextDataModel")
    }

    @NSManaged public var text: String?
    @NSManaged public var textColor: String?
    @NSManaged public var textFont: String?
    @NSManaged public var textFormat: String?
    @NSManaged public var textSize: Float
    @NSManaged public var textmodel: EditorBaseModel?

}

extension TextDataModel : Identifiable {

}

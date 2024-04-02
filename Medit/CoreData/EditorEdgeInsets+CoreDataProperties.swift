//
//  EditorEdgeInsets+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension EditorEdgeInsets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorEdgeInsets> {
        return NSFetchRequest<EditorEdgeInsets>(entityName: "EditorEdgeInsets")
    }

    @NSManaged public var bottom: Double
    @NSManaged public var leading: Double
    @NSManaged public var top: Double
    @NSManaged public var trailing: Double
    @NSManaged public var edgeinsets: EditorBaseModel?

}

extension EditorEdgeInsets : Identifiable {

}

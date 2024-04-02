//
//  EditorURL+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension EditorURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditorURL> {
        return NSFetchRequest<EditorURL>(entityName: "EditorURL")
    }

    @NSManaged public var url: String?
    @NSManaged public var urls: EditorTaskModel?

}

extension EditorURL : Identifiable {

}

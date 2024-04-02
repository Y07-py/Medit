//
//  MediaDataModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension MediaDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaDataModel> {
        return NSFetchRequest<MediaDataModel>(entityName: "MediaDataModel")
    }

    @NSManaged public var image: Data?
    @NSManaged public var mediadata: EditorBaseModel?

}

extension MediaDataModel : Identifiable {

}

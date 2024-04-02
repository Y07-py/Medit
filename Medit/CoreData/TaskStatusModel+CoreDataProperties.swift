//
//  TaskStatusModel+CoreDataProperties.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/27.
//
//

import Foundation
import CoreData


extension TaskStatusModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskStatusModel> {
        return NSFetchRequest<TaskStatusModel>(entityName: "TaskStatusModel")
    }

    @NSManaged public var doing: String?
    @NSManaged public var done: String?
    @NSManaged public var waiting: String?
    @NSManaged public var status: EditorTaskModel?

}

extension TaskStatusModel : Identifiable {

}

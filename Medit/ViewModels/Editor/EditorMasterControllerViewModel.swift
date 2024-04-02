//
//  EditorMasterControllerViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/23.
//

import Foundation
import SwiftUI
import CoreData

class EditorMasterControllerViewModel: ObservableObject {
    @Published var tasklists: [EditorTaskModel] = [EditorTaskModel]()
    @Published var selectedTaskModel: EditorTaskModel? = nil
    @Published var selectedDocumentModel: EditorDocumentModel? = nil
    @Published var selectedMemoModel: EditorMemoModel? = nil
    
    private let container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "CoreData")
        self.container.loadPersistentStores { description, error in
            if let error: Error = error {
                fatalError(error.localizedDescription)
            }
        }
        fetchTaskData()
    }
    
    func fetchTaskData() {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let startofDate: Date = calendar.startOfDay(for: .now)
        guard let nextDate: Date = calendar.date(byAdding: .day, value: 1, to: startofDate) else { return }
        
        let request: NSFetchRequest = NSFetchRequest<EditorTaskModel>(entityName: "EditorTaskModel")
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true, selector: nil)]
        let firstpredicate: NSPredicate = NSPredicate(format: "startDate >= %@", startofDate as NSDate)
        let lastpredicate: NSPredicate = NSPredicate(format: "startDate < %@", nextDate as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstpredicate, lastpredicate])
        do {
            self.tasklists = try self.container.viewContext.fetch(request)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updataTaskData(completion: @escaping () -> (EditorTaskModel)) {
        if let index: Int = self.tasklists.firstIndex(where: {$0.id == self.selectedTaskModel?.id}) {
            self.container.viewContext.delete(self.tasklists[index])
            self.tasklists.insert(completion(), at: index)
            self.saveData()
        }
    }
    
    func deleteTaskData(entity: EditorTaskModel) {
        self.container.viewContext.delete(entity)
        self.saveData()
        self.fetchTaskData()
        
    }
    
    func saveData() {
        do {
            try self.container.viewContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

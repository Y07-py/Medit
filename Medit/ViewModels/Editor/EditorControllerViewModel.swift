//
//  EditorControllerViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/23.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class EditorControllerViewModel: ObservableObject {
    @Published var lineList: [EditorDataBaseModel] = []
    @Published var isPopupEditor: Bool = false
    @Published var isKeyboardActive: Bool = false
    @Published var isTapped: Bool = false
    @Published var cursorPositionX: CGFloat = 0
    @Published var cursorPositionY: CGFloat = 0
    @Published var taskStartedAt: Date = .init()
    @Published var taskEndedAt: Date = {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        guard let endedDate: Date = calendar.date(byAdding: .day, value: 1, to: .init()) else { return  .init() }
        return endedDate
    }()
    @Published var isRepeat: Bool = false
    
    @Published var removedIndex: Int = 0
    @Published var currentLineType: listType = .normal
    @Published var returnedLineId: String?
    @Published var focusReminder: Focusable?
    @Published var coverImage: UIImage? = nil
    @Published var title: String = ""
    @Published var isFinished: Bool = false
    @Published var islineNumberChanged: Bool = false
    @Published var selectedlineId: String? = nil
    @Published var isFolderActive: Bool = false
    @Published var selectedTaskModel: EditorTaskModel?
    
    private var cancellable: Set<AnyCancellable> = []
    private let container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "CoreData")
        self.container.loadPersistentStores { description, error in
            if let error: Error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        $selectedTaskModel
            .receive(on: RunLoop.main)
            .sink { selectedModel in
                DispatchQueue.main.async {
                    if let taskModel: EditorTaskModel = selectedModel {
                        self.title = taskModel.title ?? ""
                        if let imageData: Data = taskModel.coverImage {
                            if let image: UIImage = UIImage(data: imageData) {
                                self.coverImage = image
                            }
                        }
                        self.fetchTaskModel(taskModel)
                    }
                }
            }
            .store(in: &cancellable)
        
        $removedIndex
            .receive(on: RunLoop.main)
            .sink { index in
                if (index > 0) {
                    let baseModel: EditorDataBaseModel = self.lineList[index - 1]
                    self.focusReminder = .row(id: baseModel.id.uuidString)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        for targetIndex in index + 1 ..< self.lineList.count {
                            self.lineList[targetIndex].lineNumber -= 1
                        }
                        self.lineList.remove(at: index)
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func addTaskModel(entity: EditorTaskModel? = nil) {
        let newDataModel: EditorTaskModel = EditorTaskModel(context: self.container.viewContext)
        newDataModel.title = self.title
        newDataModel.coverImage = self.coverImage?.pngData()
        newDataModel.startDate = self.taskStartedAt
        newDataModel.endData = self.taskEndedAt
        newDataModel.isRepeat = self.isRepeat
            
        for (index, item) in self.lineList.enumerated() {
            let dataModel: EditorBaseModel = EditorBaseModel(context: self.container.viewContext)
            if let textData: EditorDataTextModel = item.textData {
                dataModel.textmodel = .init(context: self.container.viewContext)
                dataModel.textmodel?.text = textData.text
                dataModel.textmodel?.textFont = textData.textFont
                dataModel.textmodel?.textColor = textData.textColor.converttoHex()
                dataModel.textmodel?.textSize = Float(textData.textSize)
                dataModel.textmodel?.textFormat = textData.textFormat.rawValue
            }
                
            if let mediaData: EditorDataMediaModel = item.mediaData {
                    if let imageData: Data = mediaData.image.pngData() {
                        dataModel.mediadata = .init(context: self.container.viewContext)
                        dataModel.mediadata?.image = imageData
                    }
            }
                
            dataModel.createdAt = .init()
            dataModel.lineNumber = Int64(item.lineNumber)
                
            dataModel.edgeinsets = .init(context: self.container.viewContext)
            dataModel.edgeinsets?.top = item.lineEdgeInsets.top
            dataModel.edgeinsets?.leading = item.lineEdgeInsets.leading
            dataModel.edgeinsets?.bottom = item.lineEdgeInsets.bottom
            dataModel.edgeinsets?.trailing = item.lineEdgeInsets.trailing
            
            dataModel.textAlignment = item.textAlignment.rawValue
            dataModel.listType = item.listType.rawValue
            dataModel.separateHeight = item.separateHeight ?? .zero
            dataModel.id = item.id
            dataModel.priority = Int64(index)
                
            newDataModel.addToBasemodels(dataModel)
        }
        self.saveData()
    }
    
    func saveData() {
        do {
            try self.container.viewContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateTaskModel() -> EditorTaskModel {
        let newDataModel: EditorTaskModel = EditorTaskModel(context: self.container.viewContext)
        newDataModel.title = self.title
        newDataModel.coverImage = self.coverImage?.pngData()
            
        for (index, item) in self.lineList.enumerated() {
            let dataModel: EditorBaseModel = EditorBaseModel(context: self.container.viewContext)
            if let textData: EditorDataTextModel = item.textData {
                dataModel.textmodel = .init(context: self.container.viewContext)
                dataModel.textmodel?.text = textData.text
                dataModel.textmodel?.textFont = textData.textFont
                dataModel.textmodel?.textColor = textData.textColor.converttoHex()
                dataModel.textmodel?.textSize = Float(textData.textSize)
                dataModel.textmodel?.textFormat = textData.textFormat.rawValue
            }
                
            if let mediaData: EditorDataMediaModel = item.mediaData {
                    if let imageData: Data = mediaData.image.pngData() {
                        dataModel.mediadata = .init(context: self.container.viewContext)
                        dataModel.mediadata?.image = imageData
                    }
            }
                
            dataModel.createdAt = .init()
            dataModel.lineNumber = Int64(item.lineNumber)
                
            dataModel.edgeinsets = .init(context: self.container.viewContext)
            dataModel.edgeinsets?.top = item.lineEdgeInsets.top
            dataModel.edgeinsets?.leading = item.lineEdgeInsets.leading
            dataModel.edgeinsets?.bottom = item.lineEdgeInsets.bottom
            dataModel.edgeinsets?.trailing = item.lineEdgeInsets.trailing
                
            dataModel.textAlignment = item.textAlignment.rawValue
            dataModel.listType = item.listType.rawValue
            dataModel.separateHeight = item.separateHeight ?? .zero
            dataModel.id = item.id
            dataModel.priority = Int64(index)
                
            newDataModel.addToBasemodels(dataModel)
        }
        self.saveData()
        return newDataModel
    }
    
    
    // CoreDataからデータを取得するメソッドではなく。EditorControllerにまつわる操作。
    
    func fetchTaskModel(_ taskModel: EditorTaskModel) {
        if let editorbaseModels: NSSet = taskModel.basemodels {
            let editorbaseModels = editorbaseModels.sortedArray(using: [NSSortDescriptor(key: "priority", ascending: true)])
            for datamodel in editorbaseModels {
                var editorBaseModel: EditorDataBaseModel = .init()
                if let baseModel: EditorBaseModel = datamodel as? EditorBaseModel {
                    if let textData: TextDataModel = baseModel.textmodel {
                        editorBaseModel.textData = .init(textSize: CGFloat(textData.textSize), textColor: .init(hex: textData.textColor ?? "000000"), textFont: textData.textFont ?? "")
                        editorBaseModel.textData?.text = textData.text ?? ""
                        editorBaseModel.textData?.textFormat = .init(rawValue: textData.textFormat!) ?? .normal
                    }
                    
                    if let mediadata: MediaDataModel = baseModel.mediadata {
                        if let imageData: Data = mediadata.image {
                            if let image: UIImage = UIImage(data: imageData) {
                                editorBaseModel.mediaData = .init(image: image)
                            }
                        }
                    }
                    
                    editorBaseModel.lineNumber = Int(baseModel.lineNumber)
                    editorBaseModel.listType = .init(rawValue: baseModel.listType!) ?? .normal
                    editorBaseModel.lineEdgeInsets = .init(top: CGFloat(baseModel.edgeinsets?.top ?? 5), leading: CGFloat(baseModel.edgeinsets?.leading ?? 20), bottom: CGFloat((baseModel.edgeinsets?.bottom ?? .zero)), trailing: CGFloat(baseModel.edgeinsets?.trailing ?? 20))
                    editorBaseModel.textAlignment = .init(rawValue: baseModel.textAlignment!) ?? .left
                    editorBaseModel.createdDate = baseModel.createdAt ?? .init()
                    editorBaseModel.separateHeight = baseModel.separateHeight
                    self.lineList.insert(editorBaseModel, at: Int(baseModel.priority))
                }
            }
        }
    }
}


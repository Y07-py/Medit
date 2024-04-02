//
//  CalendarViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/06.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class CalendarViewModel: ObservableObject {
    
    @Published var monthList: [Item<MonthModel>] = []
    @Published var dateList: [Item<DayModel>] = []
    @Published var scrollPosition: String?
    @Published var timelinescrollPosition: String? = ""
    @Published var currentDate: String
    @Published var currentPageProgress: CGFloat?
    @Published var currentMonthDate: Date
    @Published var currentDateTimeSheet: CGFloat
    @Published var currentTimeID: UUID = .init()
    @Published var currentTimelineDate: Date = .now
    @Published var selectedDate: Date = .now
    @Published var selectedTimelineDate: Date = .now
    @Published var currentTimelineIndex: Int = .zero
    @Published var istappedDate: Bool = false
    
    private var subscriptions: Set<AnyCancellable> = []
    static let container:NSPersistentContainer = NSPersistentContainer(name: "CoreData")
    
    init() {
        Self.container.loadPersistentStores { _, error in
            if let error: Error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        self.monthList = Self.createMonthList(.init())
        self.currentDate = Self.convertDatetoString(.init())
        self.currentMonthDate = .init()
        self.currentDateTimeSheet = Self.carculateDateforTimeSheet(.init())
        self.scrollPosition = self.monthList[Self.convertDatetoInt(.init())-1].data.id.uuidString
        self.dateList = Self.createTimeLineDateList(Date.now) { daylist in
            self.timelinescrollPosition = daylist.first?.id.uuidString
        }
        
        $scrollPosition
            .receive(on: RunLoop.main)
            .sink { stringid in
                DispatchQueue.main.async { [self] in
                    if let month: Date = self.monthList.first(where: { $0.data.id.uuidString == stringid })?.data.date {
                        self.currentDate = Self.convertDatetoString(month)
                    }
                    if let monthIndex: Int = self.monthList.firstIndex(where: {$0.data.id.uuidString == stringid}) {
                        let lastMonth: Item<MonthModel> = self.monthList[11]
                        if (monthIndex == 11) {
                            self.monthList[0].data.date = Self.plusMonth(lastMonth.data.date)
                            self.monthList[0].data.days = Self.createDayList(self.monthList[0].data.date)
                            for index in 0 ..< 5 {
                                self.monthList[index + 1].data.date = Self.plusMonth(self.monthList[index].data.date)
                                self.monthList[index + 1].data.days = Self.createDayList(self.monthList[index + 1].data.date)
                            }
                        }
                        if (monthIndex == 9) {
                            self.monthList[6].data.date = Self.minusMonth(self.monthList[7].data.date)
                            self.monthList[6].data.days = Self.createDayList(self.monthList[6].data.date)
                            for index in 0 ..< 6 {
                                self.monthList[6 - index - 1].data.date = Self.minusMonth(self.monthList[6 - index].data.date)
                                self.monthList[6 - index - 1].data.days = Self.createDayList(self.monthList[6 - index - 1].data.date)
                            }
                        }
                        if (monthIndex == 4) {
                            self.monthList[6].data.date = Self.plusMonth(self.monthList[5].data.date)
                            self.monthList[6].data.days = Self.createDayList(self.monthList[6].data.date)
                            for index in 0 ..< 5 {
                                self.monthList[6 + index + 1].data.date = Self.plusMonth(self.monthList[6 + index].data.date)
                                self.monthList[6 + index + 1].data.days = Self.createDayList(self.monthList[6 + index + 1].data.date)
                            }
                        }
                        if (monthIndex == 0) {
                            self.monthList[11].data.date = Self.minusMonth(self.monthList[0].data.date)
                            self.monthList[11].data.days = Self.createDayList(self.monthList[11].data.date)
                            for index in 0 ..< 3 {
                                self.monthList[11 - index - 1].data.date = Self.minusMonth(self.monthList[11 - index].data.date)
                                self.monthList[11 - index - 1].data.days = Self.createDayList(self.monthList[11 - index - 1].data.date)
                            }
                        }
                    }
                }
            }
            .store(in: &subscriptions)
        
        $selectedTimelineDate
            .receive(on: RunLoop.main)
            .sink { value in
                let calendar: Calendar = Calendar(identifier: .gregorian)
                DispatchQueue.main.async {
                    if let index: Int = self.dateList.firstIndex(where: {calendar.isDate($0.data.date, equalTo: value, toGranularity: .day)}) {
                        self.currentTimelineIndex = index
                    }
                }
            }
            .store(in: &subscriptions)
    
        let timer: Timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentDateTimeSheet = Self.carculateDateforTimeSheet(.init())
            self.currentMonthDate = .init()
            
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    static func createDayList(_ date: Date) -> [DayModel] {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let component: DateComponents = calendar.dateComponents([.year, .month], from: date)
        let addcomponent: DateComponents = DateComponents(month: 1, day: -1)
        
        guard let firstDay: Date = calendar.date(from: component) else { return [] }
        guard let lastDay: Date = calendar.date(byAdding: addcomponent, to: firstDay) else { return [] }
        
        var list: [DayModel] = []
        if let duration: Int = calendar.dateComponents([.day], from: firstDay, to: lastDay).day {
            for index in 0 ..< duration + 1 {
                guard let day: Date = calendar.date(byAdding: .day, value: index, to: firstDay) else { return [] }
                list.append(.init(date: day, index: index, dateModel: self.createTimeSheet(day)))
            }
        }
        
        let firstWeekDate: Int = calendar.component(.weekday, from: list.first?.date ?? Date())
        for index in 0 ..< firstWeekDate - 1{
            guard let day: Date = calendar.date(byAdding: .day, value: -(index + 1), to: firstDay) else { return [] }
            list.insert(.init(date: day, index: -1, dateModel: self.createTimeSheet(day)), at: 0)
        }
        
        for index in 0 ..< 42 - list.count {
            guard let day: Date = calendar.date(byAdding: .day, value: index + 1, to: lastDay) else { return [] }
            list.append(.init(date: day, index: -1, dateModel: self.createTimeSheet(day)))
        }
        
        return list
    }
    
    static func createMonthList(_ date: Date) -> [Item<MonthModel>] {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let component: DateComponents = calendar.dateComponents([.year], from: date)
        
        guard let firstMonth: Date = calendar.date(from: component) else { return [] }
        guard let lastMonth: Date = calendar.date(byAdding: .month, value: 12, to: firstMonth) else { return [] }
        
        var list: [Item<MonthModel>] = []
        if let duration: Int = calendar.dateComponents([.month], from: firstMonth, to: lastMonth).month {
            for index in 0 ..< duration {
                guard let month: Date = calendar.date(byAdding: .month, value: index, to: firstMonth) else { return [] }
                list.append(.init(data: .init(date: month, days: Self.createDayList(month), index: index+1)))
            }
        }
        return list
    }
    
    static func plusMonth(_ date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        guard let nextMonth: Date = calendar.date(byAdding: .month, value: 1 ,to: date) else { return .init() }
        return nextMonth
    }
    
    static func minusMonth(_ date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        guard let prevMonth: Date = calendar.date(byAdding: .month, value: -1, to: date) else { return .init() }
        return prevMonth
    }
    
    static func convertDatetoInt(_ date: Date) -> Int {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return Int(dateFormatter.string(from: date))!
    }
    
    static func convertDatetoString(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年M月"
        return dateFormatter.string(from: date)
    }
    
    static func carculatePageProgress(rect: CGRect, bodyView: GeometryProxy, monthIndex: Int) -> CGFloat {
        let minX: CGFloat = rect.minX
        let pageOffset: CGFloat = minX - (bodyView.size.width * CGFloat(monthIndex))
        let pageProgress: CGFloat = pageOffset / bodyView.size.width
        return pageProgress
    }
    
    static func carculateDateforTimeSheet(_ date: Date) -> CGFloat {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let component: DateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        if let hour: Int = component.hour, let minute: Int = component.minute {
            let offset: CGFloat = CGFloat(50 * hour) + (CGFloat(minute) / CGFloat(60) * CGFloat(50)) - CGFloat(50 * 14)
            return offset
        }
        return 0
    }
    
    static func createTimeSheet(_ date: Date = Date.now) -> [TimeModel] {
        var calendar: Calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(components: .init(identifier: "ja_JP"))
        let firstHour: Date = calendar.startOfDay(for: date)
        guard let lastHour: Date = calendar.date(byAdding: .hour, value: 23, to: firstHour) else { return [] }
        
        var list: [TimeModel] = []
        if let duration: Int = calendar.dateComponents([.hour], from: firstHour, to: lastHour).hour {
            for index in 0 ..< duration+1 {
                guard let date: Date = calendar.date(byAdding: .hour, value: index, to: firstHour) else { return [] }
                list.append(.init(date: date))
            }
        }
        return list
    }
    
    static func createTimeLineDateList(_ date: Date, completion: @escaping ([Item<DayModel>]) -> ()) -> [Item<DayModel>] {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let startOfDay: Date = calendar.startOfDay(for: date)
        guard let endOfDay: Date = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return [] }
        var dateList: [Item<DayModel>] = []
        
        dateList.append(.init(data: .init(date: startOfDay, index: 0, dateModel: self.createTimeSheet(startOfDay), tasks: self.fetchTaskDataFromCoreData(startOfDate: startOfDay, endOfDate: endOfDay))))
        completion(dateList)
        
        for i in 1...50 {
            if let day: Date = calendar.date(byAdding: .day, value: i, to: startOfDay) {
                let start: Date = calendar.startOfDay(for: day)
                guard let end: Date = calendar.date(byAdding: .day, value: 1, to: start) else { return [] }
                let tasks: [EditorTaskModel] = self.fetchTaskDataFromCoreData(startOfDate: start, endOfDate: end)
                dateList.append(.init(data: .init(date: day, index: i, dateModel: self.createTimeSheet(day), tasks: tasks)))
            }
        }
        
        for i in 1...50 {
            if let day: Date = calendar.date(byAdding: .day, value: (-1)*i, to: startOfDay) {
                let start: Date = calendar.startOfDay(for: day)
                guard let end: Date = calendar.date(byAdding: .day, value: 1, to: start) else { return [] }
                let tasks: [EditorTaskModel] = self.fetchTaskDataFromCoreData(startOfDate: start, endOfDate: end)
                dateList.insert(.init(data: .init(date: day, index: 50+i, dateModel: self.createTimeSheet(day), tasks: tasks)), at: 0)
            }
        }
        
        return dateList
    }
    
    static func fetchTaskDataFromCoreData(startOfDate: Date, endOfDate: Date) -> [EditorTaskModel] {
        let request: NSFetchRequest = NSFetchRequest<EditorTaskModel>(entityName: "EditorTaskModel")
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        let startOfDatePredicate: NSPredicate = NSPredicate(format: "startDate >= %@", startOfDate as NSDate)
        let endOfDatePredicate: NSPredicate = NSPredicate(format: "startDate < %@", endOfDate as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startOfDatePredicate, endOfDatePredicate])
        var tasks: [EditorTaskModel] = []
        
        do {
            tasks = try self.container.viewContext.fetch(request)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        return tasks
    }
    
    func reloadTimelineTaskData(date: Date) {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let startOfDate: Date = calendar.startOfDay(for: date)
        guard let endOfDate: Date = calendar.date(byAdding: .day, value: 1, to: startOfDate) else { return }
        
        if let index: Int = self.dateList.firstIndex(where: {calendar.isDate($0.data.date, equalTo: startOfDate, toGranularity: .day)}) {
            self.dateList[index].data.tasks = Self.fetchTaskDataFromCoreData(startOfDate: startOfDate, endOfDate: endOfDate)
        }
    }
}

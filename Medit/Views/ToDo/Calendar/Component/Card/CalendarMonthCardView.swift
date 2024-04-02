//
//  CalendarMonthCardView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/08.
//

import SwiftUI

struct CalendarMonthCardView: View {
    @EnvironmentObject var calendarModel: CalendarViewModel
    @Binding var istappedStartDate: Bool
    @Binding var istappedEndDate: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let isdeadlineView: Bool
    
    var month: MonthModel
    var body: some View {
        ForEach(month.days) { day in
            Text(converDayetoString(day.date))
                .font(.system(size: 15))
                .foregroundStyle(day.index == -1 ? .gray.opacity(0.8) : .black.opacity(0.8))
                .overlay {
                    if isSameDate(to: day.date, from: calendarModel.currentTimelineDate) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 45, height: 25)
                            .foregroundStyle(.red.opacity(0.2))
                    } else {
                        if !isdeadlineView {
                            if isSameDate(to: day.date, from: calendarModel.selectedTimelineDate) {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 45, height: 25)
                                    .foregroundStyle(.blue.opacity(0.2))
                            }
                        }
                    }
                }
                .frame(width: 45, height: 25)
                .contentShape(RoundedRectangle(cornerRadius: 5))
                .disabled(judgeDatePast(day.date, selectedDate: .init()))
                .onTapGesture {
                    self.calendarModel.selectedDate = day.date
                    let calendar: Calendar = Calendar(identifier: .gregorian)
                    let start: DateComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
                    let end: DateComponents = calendar.dateComponents([.year, .month, .day], from: endDate)
                    let date : DateComponents = calendar.dateComponents([.year, .month, .day], from: day.date)
                    
                    if !judgeDatePast(day.date, selectedDate: .init()) {
                        if (!istappedStartDate) {
                            if (calendar.date(from: end)! < calendar.date(from: date)!) {
                                endDate = day.date
                                self.istappedStartDate = false
                            } else {
                                startDate = day.date
                                self.istappedStartDate = true
                            }
                        } else  {
                            if (calendar.date(from: start)! < calendar.date(from: date)!) {
                                endDate = day.date
                                self.istappedStartDate = false
                            } else {
                                startDate = day.date
                            }
                        }
                    }
                    
                    if !isdeadlineView {
                        self.calendarModel.selectedTimelineDate = day.date
                        self.calendarModel.istappedDate.toggle()
                    }
                }
                .overlay {
                    if (judgeDatePast(day.date, selectedDate: .init()) && isdeadlineView) {
                        Rectangle()
                            .frame(width: 45, height: 1)
                            .foregroundStyle(.gray.opacity(0.8))
                    }
                }
                .background {
                    if isdeadlineView {
                        if (judgeDateDuration(first: day.date, second: endDate) || judgeDateDuration(first: startDate, second: day.date)) {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 45, height: 25)
                                .foregroundStyle(Color.init(hex: "#FF5A5F"))
                        }
                        if (judgeDatePast(day.date, selectedDate: endDate) && judgeDatePast(startDate, selectedDate: day.date)) {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color.init(hex: "#FF5A5F").opacity(0.2))
                        }
                    }
                }
        }
    }
    
    func converDayetoString(_ day: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: day)
    }
    
    func judegIsDateEqual(_ currentDate: Date, _ day: Date) -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let currentDateString: String = dateFormatter.string(from: currentDate)
        let dateString: String = dateFormatter.string(from: day)
        return currentDateString == dateString
    }
    
    func judgeDatePast(_ date: Date, selectedDate: Date) -> Bool {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let date: DateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let currentDate: DateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        return calendar.date(from: date)! < calendar.date(from: currentDate)!
    }
    
    func judgeDateDuration(first: Date, second: Date) -> Bool {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let date: DateComponents = calendar.dateComponents([.year, .month, .day], from: first)
        let currentDate: DateComponents = calendar.dateComponents([.year, .month, .day], from: second)
        return calendar.date(from: date)! == calendar.date(from: currentDate)!
    }
    
    func isSameDate(to: Date, from: Date) -> Bool {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(to, equalTo: from, toGranularity: .day)
    }
}


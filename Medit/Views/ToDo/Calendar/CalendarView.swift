//
//  CalendarView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/06.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    @State private var istappedStartDate: Bool = false
    @State private var istappedEndDate: Bool = false
    @State private var startDate: Date = .init()
    @State private var endDate: Date = {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        guard let date: Date = calendar.date(byAdding: .day, value: 1, to: .init()) else { return .init() }
        return date
    }()
    
    var body: some View {
        VStack {
                CalendarHeaderView(currentMonth: $calendarModel.currentDate)
            ZStack {
                VStack {
                    CalendarScrollView(istappedStartDate: $istappedStartDate, istappedEndDate: $istappedEndDate, startDate: $startDate, endDate: $endDate, width: UIWindow().bounds.width, height: 220, isdeadlineView: false)
                    Spacer()
                }
           
                CalendarTimelineView()
                    .environmentObject(calendarModel)
                    .offset(y: 230)
                
            }
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(CalendarViewModel())
}

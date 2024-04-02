//
//  CalendarScrollView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/08.
//

import SwiftUI
import Combine

struct CalendarScrollView: View {
    
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    @State private var offset: CGFloat = .zero
    
    @Binding var istappedStartDate: Bool
    @Binding var istappedEndDate: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    let weekDayColumns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    let width: CGFloat
    let height: CGFloat
    let isdeadlineView: Bool
    
    var daysOfWeekStack: some View {
        HStack(spacing: 5) {
            Text("日")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
            Text("月")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
            Text("火")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
            Text("水")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
            Text("木")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
            Text("金")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
            Text("土")
                .dayOfWeek()
                .font(.system(size: 8, weight: .light))
        }
        .foregroundStyle(.gray.opacity(0.8))
        .frame(height: 10)
    }
    
    var body: some View {
        ZStack {
            VStack {
                daysOfWeekStack
                    .background(.white)
                    .zIndex(1000)
                CalendarInfinityScrollView(width: width, items: calendarModel.monthList) { item in
                    LazyVGrid(columns: weekDayColumns) {
                        CalendarMonthCardView(istappedStartDate: $istappedStartDate, istappedEndDate: $istappedEndDate, startDate: $startDate, endDate: $endDate, isdeadlineView: isdeadlineView, month: item.data)
                            .environmentObject(calendarModel)
                    }
                    .padding(.top)
                    .id(item.data.id.uuidString)
                }
                .environmentObject(calendarModel)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $calendarModel.scrollPosition)
                .frame(height: height)
                
            }
            .contentShape(.rect)
            .background(.white)
        }
    }
}


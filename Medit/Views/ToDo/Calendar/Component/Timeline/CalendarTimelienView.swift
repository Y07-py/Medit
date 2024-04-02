//
//  CalendarTimelienView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/24.
//

import SwiftUI
import Combine
import CoreData

struct CalendarTimelineView: View {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation {
                    print("Hello")
                }
            }) {
                VStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 50, height: 4)
                        .foregroundStyle(.gray.opacity(0.5))
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                .frame(height: 15)
                .background(.white)
                .padding(.top, 10)
            }
            .buttonStyle(.plain)
            
            TimeLineScrollView(width: UIWindow().bounds.width, items: calendarModel.dateList) { model in
                TimelineExpandableCardView { isShow in
                    TimelineThumbnailCardView(isShow: isShow, dayModel: model)
                } expanded: { isShow in
                    TimeLineExpandedCardView(isShow: isShow, dayModel: model)
                }
                .id(model.id.uuidString)
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $calendarModel.timelinescrollPosition)
         
        }
    }
    
    func convertDatetoString(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: date)
    }
}

fileprivate struct TimeLineScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    var width: CGFloat
    var spacing: CGFloat = 0
    var items: Item
    
    @ViewBuilder var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size: CGSize = $0.size
            let repeatingCount: Int = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: spacing) {
                        ForEach(items) { item in
                            content(item)
                                .frame(width: width)
                        }
                        
                        ForEach(0..<repeatingCount, id: \.self) { index in
                            let item = Array(items)[index % items.count]
                            content(item)
                                .frame(width: width)
                        }
                    }
                    .background(
                        TimeLineScrollViewController(width: width, spacing: spacing, itemCount: items.count, repeatingCount: repeatingCount)
                            .contentShape(Rectangle())
                    )
                }
                .scrollTargetLayout()
                .onChange(of: calendarModel.currentTimelineIndex) { oldValue, newValue in
                    let uuid: UUID = self.calendarModel.dateList[newValue].id
                    withAnimation {
                        proxy.scrollTo(uuid.uuidString, anchor: UnitPoint(x: 1.0, y: .zero))
                    }
                }
            }
        }
    }
}

fileprivate struct TimeLineScrollViewController: UIViewRepresentable {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    var width: CGFloat
    var spacing: CGFloat
    var itemCount: Int
    var repeatingCount: Int
    
    let isAdded: Bool = false
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(content: self, width: width, spacing: spacing, itemCount: itemCount, repeatingCount: repeatingCount)
    }
    
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollView: UIScrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.delegate = context.coordinator
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let content: TimeLineScrollViewController
        
        var width: CGFloat
        var spacing: CGFloat
        var itemCount: Int
        var repeatingCount: Int
        
        init(content: TimeLineScrollViewController, width: CGFloat, spacing: CGFloat, itemCount: Int, repeatingCount: Int) {
            self.content = content
            self.width = width
            self.spacing = spacing
            self.itemCount = itemCount
            self.repeatingCount = repeatingCount
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let minX: CGFloat = scrollView.contentOffset.x
            let mainContentSize: CGFloat = CGFloat(itemCount) * width
            let spacingSize: CGFloat = CGFloat(itemCount) * spacing
            
            if minX > mainContentSize + spacingSize {
                scrollView.contentOffset.x -= (mainContentSize + spacingSize)
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += (mainContentSize + spacingSize)
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let minX: CGFloat = scrollView.contentOffset.x + 414.0
            let index: Int = Int(floor(minX / 414)) - 1
            self.content.calendarModel.selectedTimelineDate = self.content.calendarModel.dateList[index].data.date
        }
    }
}

fileprivate struct TimeLineExpandedCardView: View {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    @Binding var isShow: Bool
    
    let dayModel: Item<DayModel>
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section(header: sectionHeader(dayModel.data.date)) {
                        VStack(spacing: 0) {
                            ForEach(dayModel.data.dateModel) { model in
                                GeometryReader {
                                    let size: CGSize = $0.size
                                    LazyHStack(alignment: .center) {
                                        Text(convertHourtoStirng(model.date))
                                            .font(.callout)
                                            .foregroundStyle(.gray.opacity(0.8))
                                        Rectangle()
                                            .frame(width:size.width, height: 1)
                                            .foregroundStyle(.gray.opacity(0.5))
                                    }
                                    .id(model.id)
                                }
                            }
                            .frame(height: 50)
                            .padding(.leading, 10)
                            Spacer()
                                .frame(height: 250)
                        }
                        .overlay {
                            ZStack {
                                ForEach(dayModel.data.tasks ?? [], id: \.self) { model in
                                    timeTableCardView(model: model)
                                }
                                .offset(y: -(50 * 13 + 25))
                            }
                        }
                        .overlay {
                            let calendar: Calendar = Calendar(identifier: .gregorian)
                            if calendar.isDate(Date.now, equalTo: dayModel.data.date, toGranularity: .day) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(.red)
                                    .offset(y: calendarModel.currentDateTimeSheet)
                            }
                        }
                    }
                    .background(.white)
                }
            }
            .onAppear {
                let calendar: Calendar = Calendar(identifier: .gregorian)
                if calendar.isDate(dayModel.data.date, equalTo: .now, toGranularity: .day) {
                    if let index: Int = dayModel.data.dateModel.firstIndex(where: {calendar.isDate($0.date, equalTo: .now, toGranularity: .hour )}) {
                        let uuid: UUID = dayModel.data.dateModel[index].id
                        proxy.scrollTo(uuid, anchor: UnitPoint(x: .zero, y: 0.2))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func sectionHeader(_ date: Date) -> some View {
        Group {
            let datecomponent: DateComponents = returnDateComponents(date)
            let month: String = String(datecomponent.month ?? .zero)
            let day: String = String(datecomponent.day ?? .zero)
            HStack(alignment: .top) {
                Text(month + "月" + day + "日" + " " + returnWeekDay(date: date))
                    .font(.callout)
                    .foregroundStyle(.black.opacity(0.8))
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        self.isShow.toggle()
                    }
                }) {
                    Image(systemName: "lanyardcard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(.white)
        }
    }
    
    @ViewBuilder
    private func timeTableCardView(model: EditorTaskModel) -> some View {
        let startDate = model.startDate ?? .now
        let endDate = model.endData ?? .now
        let timeInterval: Double = Double(endDate.timeIntervalSince(startDate)) / (60 * 60)
        
        let dateComponent: DateComponents = returnDateComponents(model.startDate ?? Date.now)
        let cardViewOffset: Double = Double((dateComponent.hour ?? .zero) * 50) + Double(Double(dateComponent.minute ?? .zero) / Double(60) * Double(50))
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(model.title ?? "")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                Spacer()
            }
            .background(.blue.opacity(0.5))
            Spacer()
        }
        .frame(width: UIWindow().bounds.width - 50, height: 50 * timeInterval)
        .background(.blue.opacity(0.2))
        .offset(y: cardViewOffset)
        .padding(.leading, 70)
    }
    
    private func convertHourtoStirng(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func returnDateComponents(_ date: Date) -> DateComponents {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let datecomponent: DateComponents = calendar.dateComponents([.month, .day, .weekday, .hour, .minute], from: date)
        return datecomponent
    }
    
    private func isSame(_ date: Date) -> Bool {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(date, equalTo: calendarModel.currentTimelineDate, toGranularity: .day)
    }
    
    private func returnWeekDay(date: Date) -> String {
        var calendar: Calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        let datecomponent: DateComponents = returnDateComponents(date)
        
        let weekday: String = calendar.weekdaySymbols[(datecomponent.weekday ?? 0) - 1]
        return weekday
    }
}

fileprivate struct TimelineThumbnailCardView: View {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    @Binding var isShow: Bool
    
    let dayModel: Item<DayModel>
    
    var body: some View {
        VStack {
            headerView
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(dayModel.data.tasks ?? [], id: \.self) { model in
                        thumbnailTaskCardView(model: model)
                    }
                }
                .padding()
            }
            .background(.white)
            .frame(width: UIWindow().bounds.width)
        }
    }
    
    @ViewBuilder
    var headerView: some View {
        HStack {
            sectionHeader(dayModel.data.date)
        }
        .frame(height: 40)
    }
    
    @ViewBuilder
    func sectionHeader(_ date: Date) -> some View {
        Group {
            let datecomponent: DateComponents = returnDateComponents(date)
            let month: String = String(datecomponent.month ?? .zero)
            let day: String = String(datecomponent.day ?? .zero)
            HStack(alignment: .center) {
                Text(month + "月" + day + "日" + " " + returnWeekDay(date: date))
                    .font(.callout)
                    .foregroundStyle(.black.opacity(0.8))
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        self.isShow.toggle()
                    }
                }) {
                    Image(systemName: "calendar.day.timeline.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(.white)
        }
    }
    
    @ViewBuilder
    func thumbnailTaskCardView(model: EditorTaskModel) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(spacing: 5) {
                    Text(convertDatetoString(date: model.startDate ?? .now))
                        .font(.subheadline)
                    Rectangle()
                        .frame(width: 1)
                    Text(convertDatetoString(date: model.endData ?? .now))
                        .font(.subheadline)
                }
                .foregroundStyle(.gray.opacity(0.8))
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.black)
                    .padding(.leading, 10)
                Text(model.title ?? "")
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.8))
                Spacer()
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray.opacity(0.2), lineWidth: 1)
            }
        }
        .padding()
    }
    
    func returnDateComponents(_ date: Date) -> DateComponents {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let datecomponent: DateComponents = calendar.dateComponents([.month, .day, .weekday], from: date)
        return datecomponent
    }
    
    func isSame(_ date: Date) -> Bool {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        return calendar.isDate(date, equalTo: calendarModel.currentTimelineDate, toGranularity: .day)
    }
    
    func returnWeekDay(date: Date) -> String {
        var calendar: Calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        let datecomponent: DateComponents = returnDateComponents(date)
        
        let weekday: String = calendar.weekdaySymbols[(datecomponent.weekday ?? 0) - 1]
        return weekday
    }
    
    func convertDatetoString(date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

fileprivate struct TimelineExpandableCardView<Thumbnail: View, Expanded: View>: View {
    
    @State private var isShow: Bool = false
    @Namespace private var namespace
    
    @ViewBuilder var thumbnail: (Binding<Bool>) -> (Thumbnail)
    @ViewBuilder var expanded: (Binding<Bool>) -> (Expanded)
    
    var body: some View {
        ZStack {
            expandedView(isShow: $isShow)
                .opacity(isShow ? 1.0 : 0.0)
            
            thumbnailView(isShow: $isShow)
                .opacity(!isShow ? 1.0: 0.0)
        }
    }
    
    @ViewBuilder
    private func expandedView(isShow: Binding<Bool>) -> some View {
        ZStack {
            expanded(isShow)
        }
    }
    
    @ViewBuilder
    private func thumbnailView(isShow: Binding<Bool>) -> some View {
        ZStack {
            thumbnail(isShow)
        }
    }
}



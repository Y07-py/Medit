//
//  DaedLineView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/22.
//

import SwiftUI

struct DaedLineView: View {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var isdeadlineActive: Bool
    @Binding var isRepeat: Bool
    
    @State private var isstartDatePicker: Bool = false
    @State private var isendDatePicker: Bool = false
    @State private var istappedStartDate: Bool = false
    @State private var istappedEndDate: Bool = false
    
    let baseline: Date = {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        if let date: Date = calendar.date(byAdding: .day, value: 1, to: .init()) {
            return date
        }
        return .init()
    }()
    
    let isDeadlineView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Capsule()
                .foregroundStyle(.gray)
                .frame(width: 50, height: 2)
                .padding(.leading, UIWindow().bounds.width/2 - 25)
                .padding(.top, 20)
            
            HStack(alignment: .center) {
                Text("期限: ")
                    .font(.system(size: 20, weight: .semibold))
                Text(self.carcurateDuration(start: startDate, end: endDate) ?? "")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Button(action: {
                    startDate = .init()
                    endDate = self.baseline
                }) {
                    Text("リセット")
                        .foregroundStyle(.black)
                }
                .buttonStyle(.plain)
            }
            .padding([.top, .leading, .trailing])
            HStack {
                Text("開始日:")
                    .font(.system(size: 15, weight: .semibold))
                Button(action: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isstartDatePicker.toggle()
                    }
                }) {
                    HStack {
                        Text(convertDatetoString_2(startDate))
                        Image(systemName: "chevron.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .padding(.trailing, 7)
                    }
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                    }
                }
            }
            .foregroundStyle(.black)
            .padding([.top, .leading])
            
            HStack {
                Text("終了日:")
                    .font(.system(size: 15, weight: .semibold))
                Button(action: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        isendDatePicker.toggle()
                    }
                }) {
                    HStack {
                        Text(convertDatetoString_2(endDate))
                        Image(systemName: "chevron.down")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .padding(.trailing, 7)
                    }
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                    }
                }
            }
            .foregroundStyle(.black)
            .padding([.leading, .bottom])
            .padding(.top, 10)
            
            HStack {
                Toggle(isOn: $isRepeat) {
                    Text("繰り返し")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.8))
                }
            }
            .padding([.bottom, .horizontal])
            .padding(.top, 10)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.2))
                .padding(.horizontal, 10)
            
            CalendarHeaderView(currentMonth: $calendarModel.currentDate)
            CalendarScrollView(istappedStartDate: $istappedStartDate, istappedEndDate: $istappedEndDate, startDate: $startDate, endDate: $endDate, width: UIWindow().bounds.width, height: 220, isdeadlineView: isDeadlineView)
                .padding(.bottom, 10)
            
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    self.isdeadlineActive.toggle()
                }) {
                    Text("保存")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.black)
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 5))
                }
                .padding([.trailing, .bottom], 10)
            }
            .padding(5)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .environmentObject(calendarModel)
        .overlay {
            DatePicker("", selection: $startDate, in: Date.now...)
                .datePickerStyle(.wheel)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
                .padding(.horizontal, 20)
                .shadow(radius: 10, x:5, y:5)
                .opacity(isstartDatePicker ? 1 : 0)
                .environment(\.locale, Locale(identifier: "ja_JP"))
            
            DatePicker("", selection: $endDate, in: startDate...)
                .datePickerStyle(.wheel)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                }
                .padding(.horizontal, 20)
                .shadow(radius: 10, x:5, y:5)
                .opacity(isendDatePicker ? 1 : 0)
                .environment(\.locale, Locale(identifier: "ja_JP"))
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                isstartDatePicker = false
                isendDatePicker = false
            }
        }
        .toolbar(.hidden)
    }
    
    func convertDatetoString_2(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年M月d日 H:mm"
        return dateFormatter.string(from: date)
    }
    
    func carcurateDuration(start: Date, end: Date) -> String? {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let start = calendar.startOfDay(for: start)
        let end = calendar.startOfDay(for: end)
        guard let duration: Int = calendar.dateComponents([.day], from: start, to: end).day else { return nil }
        return String(duration + 1) + "日"
    }
}

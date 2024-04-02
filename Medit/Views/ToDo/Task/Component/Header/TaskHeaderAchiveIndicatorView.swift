//
//  TaskHeaderAchiveIndicatorView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/01/26.
//

import SwiftUI

struct TaskHeaderAchiveIndicatorView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(currentDatetoText(.init()))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.gray.opacity(0.8))
                    HStack(alignment: .center, spacing: 5) {
                        Text("達成率")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.8))
                        Text("50%")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    
                    
                    // progress bar
                    ZStack(alignment: .leading) {
                        ZStack(alignment: .trailing) {
                            Capsule()
                                .frame(height: 5)
                                .foregroundStyle(.gray.opacity(0.5))
                        }
                        Capsule()
                            .fill(LinearGradient(gradient: .init(colors: [.init(hex: "#5800FF"), .init(hex: "#27E1C1")]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 140, height: 5)
                    }
                    .padding([.top, .bottom])
                    
                }
                .padding([.top, .bottom, .trailing])
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("現在のタスク:")
                                .font(.caption)
                                .foregroundStyle(.black.opacity(0.8))
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding([.top, .leading])
                    HStack {
                        VStack(alignment: .leading) {
                            Text("次のタスク:")
                                .font(.caption)
                                .foregroundStyle(.black.opacity(0.8))
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
                }
                .frame(width: 200, height: 100)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.8), lineWidth: 1)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.08), radius: 5, x:5, y:5)
                .shadow(color: .black.opacity(0.08), radius: 5, x:-5, y:-5)
            }
        }
        .frame(width: UIWindow().bounds.width - 50, height: 110)
    }
    
    private func currentDatetoText(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月dd日 EEE曜日"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    TaskHeaderAchiveIndicatorView()
}

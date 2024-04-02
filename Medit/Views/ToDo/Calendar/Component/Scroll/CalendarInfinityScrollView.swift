//
//  InfinityScrollView.swift
//  Medit
//
//  Created by 木本瑛介 on 2023/12/20.
//

import Foundation
import SwiftUI
import Combine

struct CalendarInfinityScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    var width: CGFloat
    var items: Item
    var spacing: CGFloat = 0
    @ViewBuilder var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size: CGSize = $0.size
            let repeatingCount: Int = Int((size.width  / width).rounded()) + 1
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: spacing) {
                        ForEach(items) { item in
                            content(item)
                                .frame(width: width)
                        }
                        ForEach(0 ..< repeatingCount, id: \.self) { index in
                            let item = Array(items)[index % items.count]
                            content(item)
                                .frame(width: width)
                        }
                    }
                    .background {
                        ScrollViewController(width: width, spacing: spacing, itemCount: items.count, repeatingCount: repeatingCount, calendarModel: _calendarModel)
                            .contentShape(Rectangle())
                    }
                }
                .scrollTargetLayout()
            }
        }
    }
}

fileprivate struct ScrollViewController: UIViewRepresentable {
    
    var width: CGFloat
    var spacing: CGFloat
    var itemCount: Int
    var repeatingCount: Int
    
    @EnvironmentObject var calendarModel: CalendarViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(width: width, spacing: spacing, itemCount: itemCount, repeatingCount: repeatingCount, contentView: self)
    }
    
    func makeUIView(context: Context) ->  UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollView: UIScrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isAdded = true
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemCount: Int
        var repeatingCount: Int
        
        let contentView: ScrollViewController
        
        init(width: CGFloat, spacing: CGFloat, itemCount: Int, repeatingCount: Int, contentView: ScrollViewController) {
            self.width = width
            self.spacing = spacing
            self.itemCount = itemCount
            self.repeatingCount = repeatingCount
            self.contentView = contentView
        }
        
        var isAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let minx: CGFloat = scrollView.contentOffset.x
            let mainContentSize: CGFloat = CGFloat(itemCount) * width
            let spacingSize: CGFloat = CGFloat(itemCount) * spacing
            
            if minx >= (mainContentSize + spacingSize) {
                scrollView.contentOffset.x -= (mainContentSize + spacingSize)
            }
            if minx < 0 {
                scrollView.contentOffset.x += (mainContentSize + spacingSize)
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let minx: CGFloat = scrollView.contentOffset.x
            let scrollIndex: Int = Int(minx / width)
            contentView.calendarModel.scrollPosition = contentView.calendarModel.monthList[scrollIndex].data.id.uuidString
        }
    }
}


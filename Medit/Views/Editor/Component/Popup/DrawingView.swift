//
//  DrawingView.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/04.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @EnvironmentObject var editorController: EditorControllerViewModel
    @EnvironmentObject var routeView: NavigationRouterViewModel<Route>
    @State private var canvas: PKCanvasView = .init()
    @State private var selectedItem: Int = 0
    @State private var isEraser: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            HeaderView()
            DrawingViewController(canvas: $canvas, isEraser: $isEraser)
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button(action: {
                routeView.pop(1)
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
                    .contentShape(Rectangle())
            }
            Spacer()
            ItemButton(systemName: "applepencil.tip", item: 0, namespace: namespace, isErase: false)
            ItemButton(systemName: "eraser", item: 1, namespace: namespace, isErase: true)
            ItemButton(systemName: "rectangle.and.pencil.and.ellipsis", item: 2, namespace: namespace, isErase: false)
            SaveButton
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: 40)
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func ItemButton(systemName: String, item: Int, namespace: Namespace.ID, isErase: Bool) -> some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.selectedItem = item
                    self.isEraser = isErase
                }
            }) {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(selectedItem == item ? .black : .gray.opacity(0.4))
                    .contentShape(Rectangle())
            }
            if (selectedItem == item) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.black)
                    .matchedGeometryEffect(id: "namespace", in: namespace)
            } else {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.clear)
            }
        }
        .frame(width: 40)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    var SaveButton: some View {
        Button(action: {}) {
            Text("保存")
                .font(.system(size: 15, weight: .light))
                .frame(width:40, height: 30)
                .foregroundStyle(.white)
                .background(.black                      )
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 0.5)
                }
        }
    }
}

struct DrawingViewController: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var isEraser: Bool
    
    let ink = PKInkingTool(.pencil, color: .black)
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isEraser ? eraser : ink
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isEraser ? eraser : ink
    }
}

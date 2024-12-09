//
//  DrawningCanvasView.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    @Binding var pencilType: PKInkingTool.InkType
    @Binding var color: Color
    @Binding var isEraserActive: Bool
    
    var ink: PKInkingTool {
        PKInkingTool(pencilType, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isEraserActive ? eraser : ink
        canvas.backgroundColor = .clear
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool =  isEraserActive ? eraser : ink
    }
}

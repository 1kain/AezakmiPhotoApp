//
//  PhotoEditorScreenViewModel.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 09.12.2024.
//


import SwiftUI
import PencilKit

class PhotoEditorViewModel: ObservableObject {
    
    @Published var image: UIImage = UIImage()
    @Published var originalImage: UIImage = UIImage()
    
    @Published var showingFilters = false
    @Published var showingTextEditor = false
    @Published var isDrawingMode = false
    @Published var isTextMode = false
    @Published var isRotatingMode = false
    
    @Published var canvas = PKCanvasView()
    @Published var drawningTool: PKInkingTool.InkType = .pen
    @Published var drawningColor: Color = .red
    @Published var drawningWidth: CGFloat = 5
    @Published var isEraserActive = false
    
    @Published var scale: CGFloat = 1.0
    @Published var accumulatedScale: CGFloat = 1.0
    
    @Published var rotation: Angle = .zero
    @Published var accumulatedRotation: Angle = .zero
    
    @Published var textOverlay: String = ""
    @Published var textColor: Color = .white
    @Published var fontSize: CGFloat = 50
    
    @Published var textPosition = CGPoint(x: 100, y: 100)
    @Published var dragOffset = CGSize.zero
    @Published var textRotation: Angle = .zero
    @Published var textRotationAccumulated: Angle = .zero
    @Published var textScale: CGFloat = 1.0
    @Published var textScaleAccumulated: CGFloat = 1.0
    
    @Published var selectedFilterName: String? = nil
    
    let filters: [String: CIFilter] = [
        "sepiaTone": CIFilter.sepiaTone(),
        "photoEffectNoir": CIFilter.photoEffectNoir(),
        "colorMonochrome": CIFilter.colorMonochrome()
    ]
    
    init(image: UIImage, originalImage: UIImage) {
        self.image = image
        self.originalImage = originalImage
    }
    
    func applyFilter(_ filter: CIFilter) {
        guard let filteredImage = originalImage.getFilteredImage(filter) else { return }
        image = filteredImage
    }
    
    func reset() {
        image = originalImage
        accumulatedScale = 1.0
        accumulatedRotation = .zero
        textScaleAccumulated = 1.0
        textRotationAccumulated = .zero
        textOverlay = ""
    }
    
    func saveDrawing() {
        let drawingImage = canvas.drawing.image(from: canvas.bounds, scale: UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let canvasScaleX = image.size.width / canvas.bounds.width
        let canvasScaleY = image.size.height / canvas.bounds.height
        let drawingRect = CGRect(
            x: 0,
            y: 0,
            width: canvas.bounds.width * canvasScaleX,
            height: canvas.bounds.height * canvasScaleY
        )
        image.draw(in: CGRect(origin: .zero, size: image.size))
        drawingImage.draw(in: drawingRect)
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let combinedImage = combinedImage {
            self.image = combinedImage
        }
        canvas.drawing = PKDrawing()
    }
    
    func saveText() {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        
        let scaleX = image.size.width / canvas.bounds.width
        let scaleY = image.size.height / canvas.bounds.height
        let scale = min(scaleX, scaleY)
        
        let positionX = (textPosition.x + dragOffset.width) * scale
        let positionY = (textPosition.y + dragOffset.height) * scale
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize * scale),
            .foregroundColor: UIColor(textColor)
        ]
        
        let attributedString = NSAttributedString(string: textOverlay, attributes: textAttributes)
        let textSize = attributedString.size()
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.translateBy(x: positionX, y: positionY)
        context.scaleBy(x: textScaleAccumulated, y: textScaleAccumulated)
        context.rotate(by: CGFloat(textRotationAccumulated.radians))
        let textRect = CGRect(
            origin: CGPoint(x: -textSize.width / 2, y: -textSize.height / 2),
            size: textSize
        )
        attributedString.draw(in: textRect)
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let combinedImage = combinedImage {
            self.image = combinedImage
        }
        textOverlay = ""
    }
    
    func saveRotatedImage() {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.rotate(by: CGFloat(accumulatedRotation.radians))
        context.translateBy(x: -image.size.width / 2, y: -image.size.height / 2)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let rotatedImage = rotatedImage {
            self.image = rotatedImage
        }
        accumulatedRotation = .zero
    }
    
    func shareImage() {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            
            if let popoverController = activityController.popoverPresentationController {
                popoverController.sourceView = rootViewController.view
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50, width: 1, height: 1)
            }
            rootViewController.present(activityController, animated: true, completion: nil)
        }
    }
}

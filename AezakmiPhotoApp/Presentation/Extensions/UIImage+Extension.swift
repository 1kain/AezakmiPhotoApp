//
//  UIImage+Extension.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUI
import CoreImage

extension UIImage {
    
    func getFilteredImage(_ filter: CIFilter) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let orientation = self.imageOrientation
        let context = CIContext()
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage, scale: 1.0, orientation: orientation)
        }
        return nil
    }
}

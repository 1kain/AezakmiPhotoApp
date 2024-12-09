//
//  PhotoEditorScreenViewModel.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 09.12.2024.
//

import SwiftUI

class PhotoPickerScreenViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage? = nil
    @Published var isPickerPresented: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func resetImage() {
        selectedImage = nil
    }
}

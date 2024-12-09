//
//  PhotoPicker.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
        
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    init(
        _ selectedImage: Binding<UIImage?>,
        _ sourceType: UIImagePickerController.SourceType
    ) {
        self._selectedImage = selectedImage
        self.sourceType = sourceType
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                picker.dismiss(animated: true)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

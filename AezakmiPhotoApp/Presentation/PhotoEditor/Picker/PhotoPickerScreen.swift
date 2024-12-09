//
//  PhotoEditor.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUI

struct PhotoPickerScreen: View {
    
    @StateObject private var viewModel = PhotoPickerScreenViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.selectedImage {
                    PhotoEditorScreen(
                        image,
                        viewModel.resetImage
                    )
                } else {
                    choosePhoto
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.selectedImage == nil {
                        NavigationLink {
                            AccountScreen()
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .font(.title3)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isPickerPresented) {
                PhotoPicker($viewModel.selectedImage, viewModel.sourceType)
            }
            .navigationTitle("Редактор фото")
        }
    }
    
    private var choosePhoto: some View {
        List {
            Section {
                Button {
                    viewModel.sourceType = .photoLibrary
                    viewModel.isPickerPresented.toggle()
                } label: {
                    Label("Выбрать из библиотеки", systemImage: "photo")
                }
            }
            
            Section {
                Button {
                    viewModel.sourceType = .camera
                    viewModel.isPickerPresented.toggle()
                } label: {
                    Label("Сделать фото", systemImage: "camera")
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    PhotoPickerScreen()
}

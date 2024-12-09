//
//  RoundedModifier.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUICore

extension View {
    
    func rounded() -> some View {
        self
            .padding(4)
            .frame(height: 50)
            .background(.thickMaterial)
            .cornerRadius(25)
    }
}

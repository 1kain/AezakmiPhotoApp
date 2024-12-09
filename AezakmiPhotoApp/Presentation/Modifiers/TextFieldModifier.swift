//
//  TextFieldModifier.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 06.12.2024.
//

import SwiftUICore

extension View {
    
    func textFieldViewStyle() -> some View {
        self
            .padding()
            .frame(height: 52)
            .accentColor(.white)
            .foregroundStyle(.white)
            .background(Color.white.opacity(0.2))
            .font(.headline)
            .autocorrectionDisabled()
            .autocapitalization(.none)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

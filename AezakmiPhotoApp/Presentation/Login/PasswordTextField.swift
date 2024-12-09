//
//  SwiftUIView.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 09.12.2024.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding private var password: String
    @Binding private var showPassword: Bool
    
    init(
        _ password: Binding<String>,
        _ showPassword: Binding<Bool>
    ) {
        self._password = password
        self._showPassword = showPassword
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if showPassword {
                    TextField("Пароль", text: $password)
                        .textFieldViewStyle()
                } else {
                    SecureField("Пароль", text: $password)
                        .textFieldViewStyle()
                }
            }
            eyeButton
        }
    }
    
    private var eyeButton: some View {
        Button {
            showPassword.toggle()
        } label: {
            Image(systemName:showPassword ? "eye" : "eye.slash")
                .symbolVariant(.fill)
                .foregroundStyle(.white.opacity(0.8))
                .padding(.vertical)
        }
        .padding(.trailing)
    }
}

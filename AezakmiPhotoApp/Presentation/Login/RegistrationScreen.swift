//
//  RegistrationScreen.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 06.12.2024.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @EnvironmentObject private var authProvider: AuthProvider
    
    @State private var showPassword: Bool = false
        
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Регистрация")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Spacer()
            }
            TextField("Почта", text: $authProvider.email)
                .keyboardType(.emailAddress)
                .textFieldViewStyle()
            PasswordTextField($authProvider.password, $showPassword)
            PasswordTextField($authProvider.confirmation, $showPassword)
            Button {
                Task {
                    Task {
                        await authProvider.registerWithEmailAndPassword()
                    }
                }
            } label: {
                Text("Зарегистрировать")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .disabled(!authProvider.isButtonActive)
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.accent)
        .foregroundStyle(.white)
    }
}

#Preview {
    RegistrationScreen()
}


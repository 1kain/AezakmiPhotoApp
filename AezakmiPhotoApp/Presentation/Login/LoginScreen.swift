//
//  LoginScreen.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 06.12.2024.
//

import SwiftUI

struct LoginScreen: View {
    
    @EnvironmentObject private var authProvider: AuthProvider
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var showPassword: Bool = false
    @State private var showRegistrationScreen: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geometry in
                VStack(spacing: 12) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.8)
                    Spacer()
                    HStack {
                        Text("Войти")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    
                    TextField("Почта", text: $authProvider.email)
                        .keyboardType(.emailAddress)
                        .textFieldViewStyle()
                    
                    PasswordTextField($authProvider.password, $showPassword)
                    
                    loginButton
                    forgotButton
                    divider
                    signInWithGoogleButton
                    Spacer()
                    Button("Создать аккаунт") {
                        showRegistrationScreen.toggle()
                    }
                    .padding()
                }
                .frame(
                    maxWidth: geometry.size.width * (horizontalSizeClass == .regular ? 0.5 : 1)
                )
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
            
            if authProvider.inProgress {
                ProgressView {
                    Text("Загрузка..")
                }
            }
            
        }
        .padding(.horizontal)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.accent)
        .sheet(isPresented: $showRegistrationScreen) {
            RegistrationScreen()
        }
        .alert("Ошибка", isPresented: $authProvider.showError) {
            Button("Хорошо") {
                authProvider.error = nil
            }
        } message: {
            Text(authProvider.error?.localizedDescription ?? "Неизвестная ошибка")
        }
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await authProvider.loginWithEmailAndPassword()
            }
        } label: {
            Text("Войти")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
        }
        .disabled(!authProvider.isButtonActive)
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
    
    private var forgotButton: some View {
        HStack {
            Spacer()
            Button("Забыли пароль?") {
                Task {
                    await authProvider.passwordRecovery()
                }
            }
            .disabled(!authProvider.isResetButtonActive)
        }
    }
    
    private var divider: some View {
        HStack {
            VStack { Divider() }
                .overlay(.white)
            Text("или")
            VStack { Divider() }
                .overlay(.white)
        }
    }
    
    private var signInWithGoogleButton: some View {
        Button {
            Task {
                await authProvider.signInWithGoogle()
            }
        } label: {
            Text("Войти c Google")
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(alignment: .leading) {
                    Image("google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, alignment: .center)
                }
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)
        .foregroundStyle(.black)
    }
    
}

#Preview {
    LoginScreen()
        .environmentObject(AuthProvider())
}

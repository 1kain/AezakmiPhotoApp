//
//  AccountStrenn.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUI

struct AccountScreen: View {
    
    @EnvironmentObject private var authProvider: AuthProvider
    
    @State private var showSendConfirmation: Bool = false
    
    var body: some View {
        List {
            
            Section {
                AccountRow("Имя", authProvider.user?.displayName ?? "Не указано")
                AccountRow("Почта", authProvider.user?.email ?? "Не указана")
            }
            
            if !authProvider.checkUserEmailVerified() {
                Section() {
                    Button("Потвердить почту") {
                        Task {
                            if await authProvider.sendEmailVerification() {
                                showSendConfirmation.toggle()
                            }
                        }
                    }
                } footer: {
                    Text("Ваш адрес электронной почты не подтвержден. Для подверждения нажмите на кнопку выше.")
                }
            }
            
            Section {
                Button {
                    authProvider.signOut()
                } label: {
                    Text("Выход")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Аккаунт")
        .alert("Ошибка", isPresented: $authProvider.showError) {
            Button("Хорошо") {
                authProvider.error = nil
            }
        } message: {
            Text(authProvider.error?.localizedDescription ?? "Неизвестная ошибка")
        }
        .alert("Готово", isPresented: $showSendConfirmation) {
            Button("Хорошо") {
                showSendConfirmation.toggle()
            }
        } message: {
            Text("Подвердите почту перейдя по ссылке в письме.")
        }
    }
}

private struct AccountRow: View {
    
    private var title: String
    private var subtitle: String
    init(
        _ title: String,
        _ subtitle: String
    ) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(subtitle)
                .font(.headline)
        }
    }
}

#Preview {
    AccountScreen()
}

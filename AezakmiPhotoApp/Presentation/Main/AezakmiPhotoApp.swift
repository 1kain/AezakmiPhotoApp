//
//  AezakmiPhotoApp.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 06.12.2024.
//

import SwiftUI

@main
struct AezakmiPhotoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authProvider = AuthProvider()
//    
    var body: some Scene {
        WindowGroup {
            PhotoPickerScreen()
                .fullScreenCover(isPresented: $authProvider.showAuth) {
                    LoginScreen()
                }
                .environmentObject(authProvider)
        }
    }
}

//
//  AppDelegate.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 06.12.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}



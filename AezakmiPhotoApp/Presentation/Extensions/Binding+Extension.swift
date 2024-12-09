//
//  Binding+Extension.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 07.12.2024.
//

import SwiftUICore

extension Binding {
    func withDefault<T>(_ defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}

extension Binding {
    func unwrap<T>() -> Binding<T>? where Value == T? {
        guard let value = self.wrappedValue else {
            return nil
        }
        return Binding<T>(
            get: { value },
            set: { self.wrappedValue = $0 }
        )
    }
}

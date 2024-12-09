//
//  String+Extension.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import Foundation

extension String {

    var containsCyrillic: Bool {
        let cyrillicRange = self.range(of: "\\p{Script=Cyrillic}", options: .regularExpression)
        return cyrillicRange != nil
    }

    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

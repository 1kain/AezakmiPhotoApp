//
//  TextEditorView.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 08.12.2024.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var textOverlay: String
    @Binding var textColor: Color
    @Binding var fontSize: CGFloat
    
    init(
        _ textOverlay: Binding<String>,
        _ textColor: Binding<Color>,
        _ fontSize: Binding<CGFloat>
    ) {
        self._textOverlay = textOverlay
        self._textColor = textColor
        self._fontSize = fontSize
    }
    
    var body: some View {
        Form {
            Section(header: Text("Текст")) {
                TextField("Текст", text: $textOverlay)
            }
            Section(header: Text("Цвет")) {
                ColorPicker("Цвет текста", selection: $textColor)
            }
            Section(header: Text("Размер")) {
                Slider(value: $fontSize, in: 10...72, step: 1) {
                    Text("Размер текста")
                }
            }
        }
        .navigationTitle("Редактирование текста")
    }
}


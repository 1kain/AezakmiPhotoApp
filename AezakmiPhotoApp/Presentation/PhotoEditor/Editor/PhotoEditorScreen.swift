//
//  PhotoEditorScreen.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 09.12.2024.
//

import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins


struct PhotoEditorScreen: View {
    
    @StateObject private var vm: PhotoEditorViewModel
    private var reset: () -> Void
    
    init(
        _ image: UIImage,
        _ reset: @escaping () -> Void
    ) {
        self._vm = StateObject(
            wrappedValue: PhotoEditorViewModel(image: image, originalImage: image)
        )
        self.reset = reset
    }

    var body: some View {
        Image(uiImage: vm.image)
            .resizable()
            .scaledToFit()
            .scaleEffect(vm.scale * vm.accumulatedScale)
            .rotationEffect(vm.rotation + vm.accumulatedRotation)
            .gesture(imageGestures)
            .overlay(
                TextOverlayView(vm: vm),
                alignment: .center
            )
            .overlay(
                DrawingOverlayView(vm: vm)
            )
            .sheet(isPresented: $vm.showingTextEditor) {
                TextEditorView($vm.textOverlay, $vm.textColor, $vm.fontSize)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: vm.reset) {
                        Text("Сбросить")
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .tint(.red)
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    if vm.showingFilters {
                        filtersRow
                    } else if vm.isDrawingMode {
                        drawningModeMenu
                    } else if vm.isTextMode {
                        textMenu
                    } else if vm.isRotatingMode {
                        rotatingMenu
                    } else {
                        menuRow
                    }
                }
            }
            .navigationTitle("")
    }
    
    private var filtersRow: some View {
        HStack {
            
            Button("", systemImage: "chevron.left") {
                vm.showingFilters.toggle()
                vm.image = vm.originalImage
            }
            .rounded()
            
            Spacer()
            
            ForEach(vm.filters.keys.sorted(), id: \.self) { filterName in
                let filter = vm.filters[filterName]!
                
                Image(uiImage: vm.originalImage.getFilteredImage(filter)!)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 50,maxHeight: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(vm.selectedFilterName == filterName ? .accent : .clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        vm.selectedFilterName = filterName
                        vm.applyFilter(filter)
                    }
            }
            
            Spacer()
            
            Button("", systemImage: "checkmark") {
                vm.showingFilters.toggle()
            }
            .rounded()
        }
    }
    
    private var menuRow: some View {
        HStack {
            Button("", systemImage: "square.and.arrow.up") {
                vm.shareImage()
            }
            .rounded()
            
            Spacer()
            
            HStack {
                
                Button("", systemImage: "camera.filters") {
                    vm.showingFilters.toggle()
                }
                
                Button("" ,systemImage: "crop.rotate") {
                    vm.isRotatingMode.toggle()
                }
                
                Button("", systemImage: "applepencil.and.scribble") {
                    vm.isDrawingMode.toggle()
                }
                
                Button("", systemImage: "textformat") {
                    vm.isTextMode.toggle()
                }
            }
            .rounded()
            
            Spacer()
            
            Button(action: reset){
                Image(systemName: "trash")
            }
            .rounded()
        }
    }
    
    private var textMenu: some View {
        HStack {
            Button("", systemImage: "chevron.left") {
                vm.isTextMode.toggle()
            }
            .rounded()
            
            Spacer()
            
            Button("", systemImage: "textformat") {
                vm.showingTextEditor.toggle()
            }
            .rounded()
            
            Spacer()
            
            Button("", systemImage: "checkmark") {
                vm.saveText()
                vm.isTextMode.toggle()
            }
            .rounded()
        }
    }
    
    private var drawningModeMenu: some View {
        HStack {
            Button("", systemImage: "chevron.left") {
                vm.isDrawingMode.toggle()
            }
            .rounded()
            
            Spacer()
            
            HStack {
                Button("", systemImage: "pencil.line") {
                    vm.drawningTool = .pen
                    vm.isEraserActive = false
                }
                .foregroundStyle(vm.drawningTool == .pen ? .white : .accent)
                
                Button("", systemImage: "highlighter") {
                    vm.drawningTool = .marker
                    vm.isEraserActive = false
                }
                .foregroundStyle(vm.drawningTool == .marker ? .white : .accent)
                
                Button("", systemImage: "eraser.line.dashed.fill") {
                    vm.isEraserActive.toggle()
                }
                .foregroundStyle(vm.isEraserActive ? .white : .accent)
                
                ColorPicker(selection: $vm.drawningColor) {}
            }
            .rounded()
            
            Spacer()
            
            Button("", systemImage: "checkmark") {
                vm.saveDrawing()
                vm.isDrawingMode.toggle()
            }
            .rounded()
        }
    }
    
    private var rotatingMenu: some View {
        
        HStack {
            
            Button("", systemImage: "chevron.left") {
                vm.accumulatedScale = 1.0
                vm.accumulatedRotation = .zero
                vm.isRotatingMode.toggle()
            }
            .rounded()
            
            Spacer()
            
            Button("", systemImage: "checkmark") {
                vm.saveRotatedImage()
                vm.isRotatingMode.toggle()
            }
            .rounded()
        }
    }

    private var imageGestures: some Gesture {
        vm.isRotatingMode ?
        SimultaneousGesture(
            RotationGesture()
                .onChanged { value in
                    vm.rotation = value
                }
                .onEnded { _ in
                    vm.accumulatedRotation += vm.rotation
                    vm.rotation = .zero
                },
            MagnificationGesture()
                .onChanged { value in
                    vm.scale = value
                }
                .onEnded { _ in
                    vm.accumulatedScale *= vm.scale
                    vm.scale = 1.0
                }
        ) : nil
    }
}

struct TextOverlayView: View {
    @ObservedObject var vm: PhotoEditorViewModel

    var body: some View {
        Text(vm.textOverlay)
            .foregroundColor(vm.textColor)
            .font(.system(size: vm.fontSize))
            .shadow(radius: 1)
            .padding()
            .position(
                x: vm.textPosition.x + vm.dragOffset.width,
                y: vm.textPosition.y + vm.dragOffset.height
            )
            .scaleEffect(vm.textScale * vm.textScaleAccumulated)
            .rotationEffect(vm.textRotation + vm.textRotationAccumulated)
            .gesture(textGestures)
    }

    private var textGestures: some Gesture {
        SimultaneousGesture(
            DragGesture()
                .onChanged { value in
                    let angle = CGFloat((vm.textRotation + vm.textRotationAccumulated).radians)
                    let scale = CGFloat(vm.textScale * vm.textScaleAccumulated)
                    let translation = value.translation

                    vm.dragOffset = CGSize(
                        width: (translation.width * cos(-angle) - translation.height * sin(-angle)) / scale,
                        height: (translation.width * sin(-angle) + translation.height * cos(-angle)) / scale
                    )
                }
                .onEnded { _ in
                    vm.textPosition = CGPoint(
                        x: vm.textPosition.x + vm.dragOffset.width,
                        y: vm.textPosition.y + vm.dragOffset.height
                    )
                    vm.dragOffset = .zero
                },
            SimultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        vm.textScale = value
                    }
                    .onEnded { _ in
                        vm.textScaleAccumulated *= vm.textScale
                        vm.textScale = 1.0
                    },
                RotationGesture()
                    .onChanged { value in
                        vm.textRotation = value
                    }
                    .onEnded { _ in
                        vm.textRotationAccumulated += vm.textRotation
                        vm.textRotation = .zero
                    }
            )
        )
    }
}

struct DrawingOverlayView: View {
    @ObservedObject var vm: PhotoEditorViewModel

    var body: some View {
        DrawingCanvasView(
            canvas: $vm.canvas,
            pencilType: $vm.drawningTool,
            color: $vm.drawningColor,
            isEraserActive: $vm.isEraserActive
        )
        .opacity(vm.isDrawingMode ? 1 : 0)
    }
}

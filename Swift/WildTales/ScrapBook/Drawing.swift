//
//  Drawing.swift
//  WildTales
//
//  Created by Yujie Wei on 2025/4/30.
//  It defines the main interface of drawing

import SwiftUI
import PencilKit


struct Drawing: View {
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        ZStack {
            if let image = model.backgroundImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Show a placeholder when no image
                Color.gray.opacity(0.1)
            }
            
            CanvasView(canvas: $model.canvas)
            
        }
        .onAppear {
            model.showToolPicker()
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
            
                Button("Save") {
                    // Action to Save
                    
                }
            }
            /* Add ToolbarItem in future
             ToolbarItem(placement: .navigationBarTrailing) {
             Button("Add Text") {
             
             }
             }
             */
        }
        
    }
}

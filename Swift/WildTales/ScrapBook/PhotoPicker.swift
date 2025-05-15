//
//  testpicker.swift
//  WildTales
//
//  Created by Yujie on 2025/4/30.
//
/*
import SwiftUI

struct PhotoPicker: View {

    @Environment(\.presentationMode) var goBack
    @StateObject var model = DrawingViewModel()

    var body: some View {
        NavigationView {
            VStack {
                
                
                // If there is an image
                if !model.imageData.isEmpty {
                    Drawing()
                        .environmentObject(model)
                        .navigationTitle("Draw")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            // Add cancel
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    model.cancelImageEditing()
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                        
                } else {
                    // Button to trigger image picker
                    Spacer()
                    Button {
                        model.showImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                        Text("Select Photo from Album")
                            .font(.title2)
                    }
                    .padding()
                    Button {
                        goBack.wrappedValue.dismiss()
                    } label: {
                        Text("Go Back")
                            .frame(width: UIScreen.main.bounds.width-270, height: 30).background(Color(.white))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay (
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.black), lineWidth: 0.5)).font(Font.custom("Inter", size: 16))
                    }.hapticOnTouch()
                    Spacer()
                }
            }
            .navigationTitle("Image Editor")
        }
        // Use sheet to dispaly ImagePicker view
        .sheet(isPresented: $model.showImagePicker) {
            ImagePicker(showPicker: $model.showImagePicker, imageData: $model.imageData)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker()
    }
}
*/

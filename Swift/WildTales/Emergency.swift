//
//  Emergency.swift
//  WildTales
//
//  Created by Kurt McCullough on 3/4/2025.
//

import SwiftUI

struct Emergency: View {
    @Binding var showEmergency: Bool
    
    var body: some View {
        
        ZStack{
            
            
            
            VStack(spacing: 20) {
                Text("Feeling Lost?")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Button("Call your parents?") {
                    //put actioej haer
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.orange)
                .cornerRadius(10)
                
                Button("Find your parents!") {
                    //put actioej haer
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                
                Image("unsafe")
                    .resizable()
                    .frame(width: 170 , height: 150)
                
                Text("Feeling Unsafe?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                
                Button("Find security ") {
                    //put actioej haer
                }
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.purple)
                .cornerRadius(10)
                
                Button("Rescue") {
                    //put actioej haer
                }
                .frame(width: 300, height: 50)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
                
            }
            .frame(width: 350, height: 600)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            
            
            
            Button(action: {
                showEmergency = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Pink"))
                    .clipShape(Circle())
            }
            .padding(.trailing, 280)
            .padding(.bottom, 520)
            
            HStack{
                Spacer()
                
                Image("Quokka_1")
                    .resizable()
                    .frame(width: 200 , height: 280)
                    .rotationEffect(Angle(degrees: -50))
                    .padding(.top, 100)
                    .padding(.leading, 400)
                
            }
           
           
                
                

            
        }
        
    }
}

#Preview {
    Emergency(showEmergency: .constant(true))
}

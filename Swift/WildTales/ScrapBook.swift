//
//  ScrapBook.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI

struct ScrapBook: View {
    var body: some View {
        NavigationView{
            NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                Image("homeButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .padding()
                    
            }
        }
        
    }
}

#Preview {
    ScrapBook()
}

//
//  ScrapBook.swift
//  WildTales
//
//  Created by Kurt McCullough on 31/3/2025.
//

import SwiftUI

struct ScrapBook: View {
    var body: some View {
        ZStack{
            /*NavigationView{
                HStack{
                    VStack{
                        NavigationLink(destination: Home().navigationBarBackButtonHidden(true)) {
                            Image("homeButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .padding()
                                
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            */
            
            TabView {
                
                ScrapBookMemories()
                    .tabItem {
                        Label("Memories", systemImage: "memories")
                    }

                ScrapBookEdit()
                    .tabItem {
                        Label("Edit", systemImage: "scissors")
                    }
            }
            

        }
        
        
    }
}

#Preview {
    ScrapBook()
}

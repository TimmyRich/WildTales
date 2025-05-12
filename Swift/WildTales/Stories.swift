//
//  Stories.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import SwiftUI

struct Stories: View {
    @Environment(\.dismiss) var dismiss  // Dismiss environment variable to dismiss the sheet

    var body: some View {
        VStack {
            Text("This is where the stories will be")
                .font(.largeTitle)
                .padding()

            Button("back") {
                dismiss()  // Dismiss the sheet and return to the Map view
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.title)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    Stories()
}

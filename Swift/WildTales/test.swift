import SwiftUI

struct hi: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hi")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: HelloView()) {
                    Text("Go to Hello")
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
                }
            }
            .navigationTitle("Hi Page")
        }
    }
}

struct HelloView: View {
    var body: some View {
        VStack {
            Text("Hello")
                .font(.largeTitle)
                .padding()
            
            NavigationLink("Back", destination: hi())
                .font(.title)
                .foregroundColor(.blue)
                .padding()
        }
        .navigationTitle("Hello Page")
    }
}

#Preview {
    hi()
}

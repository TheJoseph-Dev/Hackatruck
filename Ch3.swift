//
//  Ch3.swift
//  Challenge
//
//  Created by Turma01-23 on 14/06/25.
//

import SwiftUI

struct Ch3: View {
    @State var username: String = "";
    @State var showNameAlert: Bool = false;
    var body: some View {
        ZStack {
            Image("mario").resizable().ignoresSafeArea().blur(radius: 4).allowsHitTesting(false)
            LinearGradient(colors: [.black.opacity(0.1), .clear],
                               startPoint: .top, endPoint: .bottom) // Darker background
                    .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: -4.0) {
                Text("Your Name:")
                TextField("Name", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
            }.padding()
            
            VStack {
                Spacer()
                Button("Enter") { self.showNameAlert = true; }.frame(width: 100, height: 40).background(.cyan).foregroundStyle(.white).cornerRadius(8).padding().alert(isPresented: $showNameAlert) {
                    Alert(title: Text("Hello, \(username)!"), message: Text("Be welcome to our app!"), dismissButton: .default(Text("Got it!")))
                }
            }
            
        }
    }
}

#Preview {
    Ch3()
}

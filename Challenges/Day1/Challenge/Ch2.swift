//
//  Ch2.swift
//  Challenge
//
//  Created by Turma01-23 on 14/06/25.
//

import SwiftUI

struct Ch2: View {
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/pt/7/77/220px-Dream_Theater_-_Black_Clouds_%26_Silver_Linings.jpg"), content: { $0.image?.resizable()})
                .frame(width: 150, height: 150).clipShape(Circle()).padding()
            Spacer()
            VStack {
                Text("Black Clouds & Silver Lingins").font(.title2).bold().frame(alignment: .trailing).padding()
                Text("1M Plays on Spotify").frame(alignment: .trailing).foregroundStyle(.green)
                Text("The Best of Times").frame(alignment: .trailing).foregroundStyle(.blue)
            }.padding()
        }
    }
}

#Preview {
    Ch2()
}

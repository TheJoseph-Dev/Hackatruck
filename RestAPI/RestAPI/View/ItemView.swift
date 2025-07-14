//
//  ItemView.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import SwiftUI

struct ItemView: View {
    let item: Item;
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: self.item.image ?? "")) { image in
                image.resizable()
                    .frame(width: 200, height: 200)
            } placeholder: {
                ProgressView().progressViewStyle(.circular)
            }
            .aspectRatio(contentMode: .fit)
            
            Text(item.title ?? "")
                .fontWeight(.bold)
                .padding()
            Text("$" + String(item.price ?? -1.0))
                .padding()
            Text(item.description ?? "")
                .font(.subheadline)
                .padding()
            
            Spacer()
        }
        .padding(16)
    }
}

//
//  ItemRow.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import SwiftUI

struct ItemRow: View {
    let item: Item;
    var body: some View {
        NavigationLink(destination: ItemView(item: self.item)) {
            
            HStack {
                AsyncImage(url: URL(string: self.item.image ?? "")) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                
                Spacer()
                
                VStack {
                    Text(item.title ?? "")
                        .font(.title2)
                    Text("$" + String(item.price ?? -1.0))
                        .font(.subheadline)
                }
            }
        }
        .foregroundColor(.black)
        
    }
}

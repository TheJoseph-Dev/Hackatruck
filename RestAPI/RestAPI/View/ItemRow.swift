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
                    image.resizable()
                } placeholder: {
                    ProgressView().progressViewStyle(.circular)
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                
                Spacer()
                
                Text(item.title ?? "")
            }
            .padding(16)
        }
        .foregroundColor(.black)
        
    }
}

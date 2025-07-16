//
//  AddItemView.swift
//  RestAPI
//
//  Created by Turma01-23 on 16/07/25.
//

import SwiftUI

struct AddItemView: View {
    
    let api: API;
    
    @Environment(\.dismiss) var dismiss;
    @State var title: String = ""
    @State var price: String = ""
    @State var description: String = ""
    @State var img: String = ""
    var body: some View {
        VStack {
            Text("Add a new item!")
            TextField("Title", text: $title).padding()
            TextField("Price", text: $price).padding()
            TextField("Description", text: $description).padding()
            TextField("Image", text: $img).padding()
            Button("Add") {
                api.add(item: Item(title: title, price: Float(price) ?? -1, description: description, image: img))
                dismiss();
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

//
//  ContentView.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import SwiftUI

struct MainView: View {
    
    // @StateObject is in between the @EnvironmentObject
    // @StateObject is owned by view and recreated every time the view is loaded
    @StateObject var api: API = API();
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(api.items, id: \.id) { item in
                    ItemRow(item: item)
                    Divider()
                }
            }
        }
        .padding()
        .onAppear() {
            api.fetch()
        }
    }
    
}

#Preview {
    NavigationStack {
        MainView()
    }
}

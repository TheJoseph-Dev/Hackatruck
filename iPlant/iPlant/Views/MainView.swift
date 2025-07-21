//
//  ContentView.swift
//  iPlant
//
//  Created by Turma01-23 on 21/07/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var api: API = API(apiURL: "http://192.168.128.28:1880");
    
    var body: some View {
        List(api.plants, id: \.self) { plant in
            VStack {
                Text(plant.name)
                HStack {
                    Text("Ideal Umidity: " + String(plant.idealUmidity))
                        
                    
                    Text("Umidity: " + String(plant.umidity))
                }
                .font(.subheadline)
                .foregroundStyle(.gray)
            }
        }
        .onAppear {
            api.fetch()
        }
    }
}

#Preview {
    MainView()
}

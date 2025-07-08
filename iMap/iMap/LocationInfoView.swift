//
//  LocationInfoView.swift
//  iMap
//
//  Created by Turma01-23 on 08/07/25.
//

import SwiftUI

struct LocationInfoView: View {
    
    let location: Location
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: location.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView().progressViewStyle(.circular)
            }
            .aspectRatio(contentMode: .fit)
            
            VStack {
                Text(location.name)
                    .font(.title)
                    .bold()
                Text(location.subtitle)
                    .font(.subheadline)
                Text(location.description)
                    .font(.title2)
                    .padding()
            }
            .padding()
            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LocationInfoView(location: Location(name: "Paternon", subtitle: "Birth of Democracy", image: "https://lh3.googleusercontent.com/gps-cs-s/AC9h4no-RzRW9StQk7ZlvX2ENPZqOa-RLIbZY5X6JyNMv4jRlJahHw4p70lGwBbAUNHBwoZ1g7Chm4uW2OCYl75nBKcolox8ad94R711IuPM0QgmBzihjuHHS1mhw_BNC22t6S-LJygZ=w408-h306-k-no", description: "Birth of Democracy", latitude: 37.971608336337425, longitude: 23.726708064957055))
}

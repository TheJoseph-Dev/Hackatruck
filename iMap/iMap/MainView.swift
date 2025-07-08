//
//  MainView.swift
//  iMap
//
//  Created by Turma01-23 on 20/06/25.
//

import SwiftUI
import MapKit

let locations: [Location] = [
    Location(name: "Acropolis of Athens", subtitle: "Birth of Democracy", image: "https://lh3.googleusercontent.com/gpms-cs-s/AB8u6HbZ6MONXWuOV57L0t8SAFAvDZ3VZsMjcB1UKwavMDD-0rBajskkp6oXli_M6TMGSHY0bpEnSO9kFVQhX3ZRiELK_ppAS1GazMOGodHQByGZhv-pS7QMR0IIRnvifTh9iqnHh7mJMg=s1360-w1360-h1020-rw", description: "Socrates has been here", latitude: 37.98362778869565, longitude: 23.72603450656364),
    Location(name: "Paternon", subtitle: "Birth of Democracy", image: "https://lh3.googleusercontent.com/gps-cs-s/AC9h4no-RzRW9StQk7ZlvX2ENPZqOa-RLIbZY5X6JyNMv4jRlJahHw4p70lGwBbAUNHBwoZ1g7Chm4uW2OCYl75nBKcolox8ad94R711IuPM0QgmBzihjuHHS1mhw_BNC22t6S-LJygZ=w408-h306-k-no", description: "Birth of Democracy", latitude: 37.971608336337425, longitude: 23.726708064957055)
]

struct MainView: View {
    
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.9766, longitude: 23.7264),
        span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
    ))
    
    @State private var currentLocation: Location = locations[0]
    @State private var showLocationInfo: Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                ForEach(locations, id: \.self) { location in
                    Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        
                        Button {
                            updatePosition()
                            currentLocation = location
                            showLocationInfo = true;
                        } label: {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(.clear)
                                .clipShape(.circle)
                        }
                    }
                }
            }
            
            VStack {
                Picker("Pick a location", selection: $currentLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location.name)
                    }
                }
                .background(.white)
                .onChange(of: currentLocation) { _ in
                    updatePosition()
                }
                
                Spacer()
            }
            .pickerStyle(.menu)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showLocationInfo = true;
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showLocationInfo) {
                LocationInfoView(location: currentLocation)
            }
            
        }
        
    }
    
    func updatePosition() {
        self.position = MapCameraPosition.region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}

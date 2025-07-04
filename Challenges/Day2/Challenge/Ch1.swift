//
//  Ch1.swift
//  Challenge
//
//  Created by Turma01-23 on 15/06/25.
//

import SwiftUI

struct Object {
    let name: String;
    let velocityRange: [Int];
    let image: String;
    let color: Color;
    init(name: String, velocityRange: [Int], image: String, color: Color) {
        self.name = name
        self.velocityRange = velocityRange
        self.image = image
        self.color = color
    }
}

struct Ch1: View {
    
    @State private var distance: Float = 0.0;
    @State private var time: Float = 1.0;
    
    static private let objects: [Object] = [
        Object(name: "You", velocityRange: [0, 4], image: "turtle", color: .green),
        Object(name: "Jet", velocityRange: [500, 900], image: "jet", color: .blue),
        Object(name: "Your Mom", velocityRange: [1600, 3200], image: "earth", color: .purple)
    ]
    
    @State private var currentObject: Object = objects[0]; // @State to allow mutating it later
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("Distance (km): ")
                TextField("10", value: $distance, format: .number)
                    .keyboardType(.decimalPad)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 0.4)
                    )
                    .onChange(of: distance) { _, _ in
                        updateCurrentObject();
                    }
            }
            .padding(.bottom)
            
            VStack {
                Text("Time (h): ")
                TextField("1", value: $time, format: .number)
                    .keyboardType(.decimalPad)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 0.4)
                    )
                    .onChange(of: time) { _, _ in
                        updateCurrentObject();
                    }
            }
            
            Text(String(format: "%.2f", (distance/time)) + " km/h")
                .font(.title)
                .fontWeight(.medium)
                .padding()
            
            Spacer()
            
            VStack {
                Image(currentObject.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(color: currentObject.color.opacity(0.5), radius: 100)
                    .shadow(color: currentObject.color.opacity(0.5), radius: 20)
                    .padding(.bottom)
                
                Text(currentObject.name)
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                HStack {
                    Circle()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(currentObject.color)
                    Text("\(currentObject.velocityRange[0])-\(currentObject.velocityRange[1]) km/h")
                        .font(.subheadline)
                }.padding()
            }
            .padding()
                
        }.padding()
        Spacer()
    }
    
    private func updateCurrentObject() {
        let velocity = distance / time
        var index = 0
        while index < Ch1.objects.count && velocity > Float(Ch1.objects[index].velocityRange[1]) {
            index += 1
        }
        
        self.currentObject = Ch1.objects[index]
    }
}

#Preview {
    Ch1()
}

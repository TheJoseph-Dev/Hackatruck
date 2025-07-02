//
//  ContentView.swift
//  Challenge
//
//  Created by Turma01-23 on 14/06/25.
//

import SwiftUI

struct Ch1: View {
    var body: some View {
        VStack {
            HStack {
                Rectangle().fill(.red).frame(width: 100, height: 100)
                Spacer()
                Rectangle().fill(.blue).frame(width: 100, height: 100)
            }
            Spacer()
            HStack {
                Rectangle().fill(.green).frame(width: 100, height: 100)
                Spacer()
                Rectangle().fill(.yellow).frame(width: 100, height: 100)
            }
        }
        .padding()
    }
}

#Preview {
    Ch1()
}

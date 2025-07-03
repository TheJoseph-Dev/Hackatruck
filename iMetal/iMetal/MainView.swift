//
//  ContentView.swift
//  iMetal
//
//  Created by Turma01-23 on 15/06/25.
//

import SwiftUI

struct MainView: View {
    let start = Date();
    var body: some View {
        TimelineView(.animation) { tl in
            let time = start.distance(to: tl.date);
            
            Rectangle()
                .colorEffect(ShaderLibrary.sphSDF(.float2(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height), .float(time)))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    MainView()
}

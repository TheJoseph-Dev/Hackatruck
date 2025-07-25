//
//  ObjectFrame.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 25/07/25.
//

import SwiftUI

struct ObjectFrame: View {
    let label: YOLO.ImageLabel
    var body: some View {
        Group {
            Text("\(self.label.name)")
                .padding(8)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(8)
                .position(x: self.label.screenSpaceBoundingBox(imageSize: UIScreen.main.bounds.size).origin.x, y:  self.label.screenSpaceBoundingBox(imageSize: UIScreen.main.bounds.size).origin.y)
            
            Path { path in
                path.addRect(self.label.screenSpaceBoundingBox(imageSize: UIScreen.main.bounds.size))
            }
            .stroke(Color.red, lineWidth: 2)
        }
    }
}

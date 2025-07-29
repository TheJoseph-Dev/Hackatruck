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
        let box = label.screenSpaceBoundingBox(imageSize: UIScreen.main.bounds.size)

        ZStack(alignment: .topLeading) {
            Path { path in
                path.addRect(box)
            }
            .stroke(Color.red, lineWidth: 2)

            Text(label.name)
                .padding(8)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(8)
                .offset(x: box.origin.x, y: box.origin.y) // Adjust Y to be above box if needed
        }
    }
}


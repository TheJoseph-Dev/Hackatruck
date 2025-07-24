//
//  CameraView.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 23/07/25.
//

import SwiftUI

import SwiftUI

struct CameraController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Nothing to update for now
    }
}


struct CameraView: View {
    var body: some View {
        CameraController()
            .ignoresSafeArea()
    }
}

#Preview {
    CameraView()
}

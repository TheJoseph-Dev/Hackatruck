import SwiftUI
import AVFoundation

struct CameraView: View {
    // Esse ambiente permite fechar a view atual
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Aqui você colocaria a visualização da câmera se quiser
            // CameraPreview()
            //     .edgesIgnoringSafeArea(.all)
            
            Color.black.opacity(0.01) // camada invisível para capturar toques

            Button("") {} // botão placeholder, pode ser removido se não necessário
        }
        .contentShape(Rectangle()) // garante que a área inteira seja clicável
        .onTapGesture(count: 2) {
            dismiss() // Volta para a ContentView
        }
    }
}

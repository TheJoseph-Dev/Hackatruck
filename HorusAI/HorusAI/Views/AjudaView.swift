// AjudaView.swift

import SwiftUI

struct AjudaView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Tutorial do HorusAI")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)

                Text("Tela Principal (Início)")
                    .font(.title2)
                    .bold()
                Text("Esta é a sua tela inicial. Dê um duplo toque no círculo central para ativar a funcionalidade principal do aplicativo, como a câmera.")

                Text("Menu")
                    .font(.title2)
                    .bold()
                Text("Toque no ícone de três linhas no canto superior esquerdo para abrir o menu de navegação.")

                Text("Meu Perfil")
                    .font(.title2)
                    .bold()
                Text("No menu, acesse 'Ajustes' e depois 'Meu Perfil' para visualizar e editar suas informações.")

                Text("Histórico")
                    .font(.title2)
                    .bold()
                Text("Acesse 'Histórico' no menu para ver uma lista dos seus últimos locais registrados.")

                Text("Ajuda")
                    .font(.title2)
                    .bold()
                Text("Esta tela que você está vendo agora fornece informações sobre como usar cada parte do aplicativo.")
            }
            .padding()
        }
        .navigationTitle("Ajuda")
    }
}

#Preview {
    NavigationStack {
        AjudaView()
    }
}

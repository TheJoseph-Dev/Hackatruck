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

                Text("Início")
                    .font(.title2)
                    .bold()
                Text("A primeira tela ao abrir o app. Dê um toque em quaisquer proximidades do círculo central para ativar a Live View, com a câmera e funcionalidade principal do aplicativo.")

                Text("Configurações")
                    .font(.title2)
                    .bold()
                Text("Na tela inicial, acesse as configurações no canto superior direito para visualizar e editar suas preferências.")

                Text("Live View")
                    .font(.title2)
                    .bold()
                Text("Ao entrar na Live View, o app começará a escanear o ambiente automaticamente, é recomendado a orientação landscape para melhor eficácia. Após o escaneamento, em alguns segundos o app emitirá uma descrição sobre o ambiente. Após a primeira fala, próximas descrições podem ser ativadas com 1 toque em qualquer lugar da tela. Dê 2 toques para sair para a Tela Inicial. Segure uma quantidade predefinida de segundos para chamar o número de emergencia.")

                Text("Meu Perfil")
                    .font(.title2)
                    .bold()
                Text("No menu, acesse 'Meu Perfil' para visualizar e editar suas informações.")

                /*
                Text("Histórico")
                    .font(.title2)
                    .bold()
                Text("Acesse 'Histórico' no menu para ver uma lista dos seus últimos locais registrados.")
                */
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

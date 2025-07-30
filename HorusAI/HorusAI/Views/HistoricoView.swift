// HistoricoView.swift

/*
import SwiftUI

struct HistoricoView: View {
    @State private var historico: [LocalizacaoHistorico] = []

    var body: some View {
        Group {
            if historico.isEmpty {
                VStack {
                    Image(systemName: "location.slash")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Nenhum histórico de localização encontrado.")
                        .padding()
                        .foregroundColor(.gray)
                    Text("Movimente-se com o aplicativo em segundo plano para registrar novos locais.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                List(historico) { local in
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(local.nomeLocal)
                                .font(.headline)
                            Text(local.data.formatted(date: .long, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .refreshable {
                    carregarDados()
                }
            }
        }
        .navigationTitle("Histórico de Locais")
        .onAppear(perform: carregarDados)
        .onReceive(NotificationCenter.default.publisher(for: .historicoAtualizado)) { _ in
            carregarDados()
        }
    }
    
    func carregarDados() {
        self.historico = LocationManager.shared.carregarHistorico()
    }
}

#Preview {
    NavigationStack {
        HistoricoView()
    }
}
*/

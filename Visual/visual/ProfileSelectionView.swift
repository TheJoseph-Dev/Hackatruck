//  ProfileSelectionView.swift
/*
import SwiftUI

struct ProfileSelectionView: View {
    // Pega a instância do nosso gerenciador que foi injetada no ambiente.
    @EnvironmentObject var manager: ConfigurationManager

    var body: some View {
        NavigationView {
            List {
                ForEach(manager.configuracoesSalvas) { config in
                    // Cada item da lista é um link para a tela de edição
                    NavigationLink(destination: SettingsView(configParaEditar: config)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(config.nome).font(.headline)
                                Text(config.telefone).font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            // Mostra um checkmark se o perfil for o ativo
                            if manager.configuracaoAtiva?.id == config.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onTapGesture {
                        // Ao tocar, define este perfil como o ativo
                        manager.definirConfiguracaoAtiva(config)
                    }
                }
            }
            .navigationTitle("Perfis de Usuário")
            .toolbar {
                // Botão para adicionar um novo perfil
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(configParaEditar: nil)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
*/

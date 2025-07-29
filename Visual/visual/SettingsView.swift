import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var manager: ConfigurationManager
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false;
    
    @State private var config: UserConfig

    var body: some View {
        Form {
            Section(header: Text("Nome")) {
                TextField("Nome", text: $config.nome)
            }
            
            Section(header: Text("Emergência")) {
                Picker("Atalho", selection: $config.toques) {
                    ForEach(UserConfig.tapOptions, id: \.self) { Text("Taps: " + String($0)) }
                }
                TextField("Número de emergência", text: $config.telefone)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Voz")) {
                Picker("Voz", selection: $config.voz) {
                    ForEach(UserConfig.voiceOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())
            }
            Section(header: Text("Idioma")) {
                Picker("Idioma", selection: $config.idioma) {
                    ForEach(UserConfig.languageOptions, id: \.self) { Text($0) }
                }
            }
            
            Section {
                Button(action: {
                    Task {
                        await saveConfig()
                        showAlert = true;
                    }
                }) {
                    Text("Salvar")
                }
            }

        }
        .navigationTitle("Configurações")
        .onAppear { loadProfileData() }
        .alert("Dados Salvos", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("As configurações de usuário foram salvas com sucesso")
        }
    }
    
    func loadProfileData() {
        self.config = manager.currentConfig;
    }
    
    func saveConfig() async {
        manager.currentConfig = config;
        await manager.updateProfile()
    }
}


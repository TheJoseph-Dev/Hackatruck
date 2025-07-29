// HorusAIApp.swift (ou o nome do seu arquivo principal)

import SwiftUI

@main
struct HorusAIApp: App {
    // @StateObject cria a instância do nosso gerenciador.
    // Ele viverá enquanto o app estiver aberto.
    @StateObject private var manager = ConfigurationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}

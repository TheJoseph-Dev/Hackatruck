//
//  HorusAIApp.swift
//  HorusAI
//
//  Created by Turma01-23 on 28/07/25.
//

import SwiftUI

@main
struct HorusAIApp: App {
    let manager = ConfigurationManager()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(manager)
        }
    }
}

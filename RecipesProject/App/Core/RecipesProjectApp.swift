//
//  RecipesProjectApp.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import SwiftUI
import TipKit

@main
struct RecipesProjectApp: App {
    @State var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            RecipesHomeView()
                .environment(networkMonitor)
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}

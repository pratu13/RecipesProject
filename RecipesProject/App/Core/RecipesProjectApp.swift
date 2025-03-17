//
//  RecipesProjectApp.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import SwiftUI

@main
struct RecipesProjectApp: App {
    @State var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            RecipesHomeView()
                .environment(networkMonitor)
        }
    }
}

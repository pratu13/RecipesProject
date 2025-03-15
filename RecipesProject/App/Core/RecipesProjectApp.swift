//
//  RecipesProjectApp.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import SwiftUI

@main
struct RecipesProjectApp: App {
   @State var viewModel = RecipesViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RecipesHomeView()
                    .environment(viewModel)
            }
        }
    }
}

//
//  RecipeImageView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/12/25.
//

import SwiftUI

struct RecipeImageView: View {
    var recipeImageViewModel: RecipeImageViewModel
    let recipe: Recipe
    init(recipe: Recipe, size: ImageSize = .large) {
        self.recipe = recipe
        recipeImageViewModel = RecipeImageViewModel(size: size)
        print("Initializing RecipeImageView with recipe: \(recipe.name)")
    }
    var body: some View {
        ZStack {
            VStack {
                if let image = recipeImageViewModel.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            print("Displaying image for recipe: \(recipe.name)")
                        }
                } else if recipeImageViewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    Image(systemName: "questionmark")
                }
            }
            .frame(minWidth: 100, minHeight: 100)
        }
        .task {
            await recipeImageViewModel.getImage(for: recipe)
        }
    }
}

#Preview {
    RecipeImageView(recipe: .mock)
}

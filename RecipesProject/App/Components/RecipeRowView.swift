//
//  RecipeRowView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/13/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    var body: some View {
        HStack(alignment: .top) {
            RecipeImageView(recipe: recipe, size: .small)
            Spacer()
            VStack(alignment: .leading) {
                Spacer()
                Text(recipe.name)
                    .font(.demibold)
                    .lineLimit(2)
                Text(recipe.cuisine)
                    .font(.regular)
                Spacer()
            }
            Spacer()
           
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32)
        .frame(height: UIScreen.main.bounds.height / 5)
        .background(Color.white)
        .shadow(radius: 20, y: 10)
   
    }
}

#Preview {
    RecipeRowView(recipe: .mock)
}

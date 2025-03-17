//
//  CarousalView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/13/25.
//


import SwiftUI

struct CarousalView<Content: View>: View {
    let content: Content
    let recipes: [Recipe]
    init(recipes: [Recipe], @ViewBuilder content: ([Recipe]) -> Content) {
        self.recipes = recipes
        self.content = content(recipes)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                content
            }
            .scrollTargetLayout()
        }
        .safeAreaPadding(.horizontal, 12)
        .scrollTargetBehavior(.viewAligned)
        .animation(.none)
     
    }
}

#Preview {
    CarousalView(recipes: [.mock, .mock2]) { recipes in
        ForEach(recipes, id: \.self) { recipe in
            RecipeRowView(recipe: recipe)
        }
    }
}

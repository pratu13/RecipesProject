//
//  RecipesViewModel.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Observation
import Foundation

@Observable
class RecipesViewModel {
    
    private(set) var recipes: [Recipe] = []
    private(set) var filtered: [Recipe] = []
    var isLoading: Bool = false
    var searchText: String = "" {
        didSet {
            if (!searchText.isEmpty) {
                filterRecipes(text: searchText, startingRecipes: recipes)
            }
        }
    }

    func setMock() {
        recipes.append(Recipe.mock)
    }
    
    func getAllRecipes() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let result = await NetworkingManager.downloadData(from: .init(type: .allRecipes))
            switch result {
            case .success(let recipes):
                let decodedData = try JSONDecoder().decode(Recipes.self, from: recipes)
                await MainActor.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.recipes = decodedData.recipes
                }
            case .failure(let failure):
                print(failure)
            }
        } catch (let err) {
            print(err)
        }
    }
    
    private func filterRecipes(text: String, startingRecipes: [Recipe]) {
        guard !text.isEmpty else {
            filtered = startingRecipes
            return
        }
        let lowercasedText = text.lowercased()
        let updatedRecipes = startingRecipes.filter { recipe in
            return  recipe.name.lowercased().contains(lowercasedText) || recipe.cuisine.lowercased().contains(lowercasedText)
        }
        filtered = updatedRecipes
    }

    
}

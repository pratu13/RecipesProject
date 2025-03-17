//
//  RecipesViewModel.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//


import Foundation
import Swift
import Combine

@Observable @MainActor
class RecipesViewModel {
    
    //private var isolationQueue: DispatchQueue = DispatchQueue(label: "com.recipes", attributes: .concurrent)
    private(set) var recipes: [Recipe] = []
    private(set) var filtered: [Recipe] = []
    var error: Bool = false
    var errorString: String = ""
    var isLoading: Bool = false
    var endpoint: RecipesEndpoint = .init(type: .allRecipes)

    var searchText: String = "" {
        didSet {
            filterRecipes(text: searchText)
        }
    }

    func getAllRecipes() async  {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = await NetworkingManager.downloadData(from: endpoint)
            switch result {
            case .success(let recipes):
                let decodedData = try JSONDecoder().decode(Recipes.self, from: recipes)
                print("success")
                self.isLoading = false
                self.error = false
                self.recipes = decodedData.recipes
            case .failure(let failure):
                print("Error")
                    self.isLoading = false
                    self.errorString = failure.localizedDescription
                    self.error = true
        
            }
        } catch (let err) {
            print("Error")
                self.isLoading = false
                self.errorString = err.localizedDescription
                self.error = true
        }
        
    }
    
}

//MARK: - helpers
extension RecipesViewModel {
    
    func setMock() {
        recipes.append(Recipe.mock)
    }
    
    func filterRecipes(text: String) {
        guard !text.isEmpty else {
            filtered = recipes
            return
        }
        let lowercasedText = text.lowercased()
        let updatedRecipes = recipes.filter { recipe in
            return  recipe.name.lowercased().contains(lowercasedText) || recipe.cuisine.lowercased().contains(lowercasedText)
        }
        filtered = updatedRecipes
    }
    
}

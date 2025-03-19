//
//  RecipesViewModel.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//


import Foundation
import Swift
import Combine

enum SortOption: String, CaseIterable {
    case name, cuisine, nameReversed, cuisineReversed
    var title: String {
        switch self {
        case .name:
            return "Name"
        case .cuisine:
            return "Cuisine"
        case .nameReversed:
            return "Name"
        case .cuisineReversed:
            return "Cuisine"
        }
    }
}

@Observable @MainActor
class RecipesViewModel {
    
    //private var isolationQueue: DispatchQueue = DispatchQueue(label: "com.recipes", attributes: .concurrent)
    private(set) var recipes: [Recipe] = []
    private(set) var filtered: [Recipe] = []
    var error: Bool = false
    var errorString: String = ""
    var isLoading: Bool = false
    var selectedRecipe: Recipe? = .mock
    
    var sortOption: SortOption = .name {
        didSet {
            didSetSortOption()
        }
    }
    var endpoint: RecipesEndpoint = .init(type: .allRecipes) {
        didSet {
            Task {
               await getAllRecipes()
            }
        }
    }

    var searchText: String = "" {
        didSet {
            filtered = filterRecipes(text: searchText)
        }
    }
    
    /// uses the NetworkManager to download the recipes given an endpoint.
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
                self.errorString = ""
                self.recipes = decodedData.recipes
                sortRecipes(sort: sortOption, recipes: &self.recipes)
                self.selectedRecipe = self.recipes.first ?? .mock
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
    
    func sortWith(option: SortOption) -> SortOption {
        if (option == .name || option == .nameReversed) {
            sortOption = option == .name ? .nameReversed : .name
        } else if (option == .cuisine || option == .cuisineReversed) {
            sortOption = option == .cuisine ? .cuisineReversed : .cuisine
        }
        return sortOption
    }
    
}

//MARK: - helpers
extension RecipesViewModel {
    
    func setMock() {
        recipes.append(Recipe.mock)
    }
    
    private func filterRecipes(text: String) -> [Recipe] {
        guard !text.isEmpty else {
            return recipes
        }
        let lowercasedText = text.lowercased()
        let updatedRecipes = recipes.filter { recipe in
            return  recipe.name.lowercased().contains(lowercasedText) || recipe.cuisine.lowercased().contains(lowercasedText)
        }
        return updatedRecipes
    }
    
    private func sortRecipes(sort: SortOption, recipes: inout [Recipe]) {
        switch sort {
        case .name:
            recipes.sort { $0.name < $1.name }
        case .nameReversed:
            recipes.sort { $0.name > $1.name }
        case .cuisine:
            recipes.sort { $0.cuisine < $1.cuisine }
        case .cuisineReversed:
            recipes.sort { $0.cuisine > $1.cuisine }
        }
    }
    
    private func didSetSortOption() {
        var recipes = searchText.isEmpty ? self.recipes : self.filtered
        sortRecipes(sort: sortOption, recipes: &recipes)
        if (searchText.isEmpty) {
            self.recipes = recipes
        } else {
            self.filtered = recipes
        }
    }
    
    private func filterAndSortRecipes(text: String, sortingOption: SortOption) -> [Recipe] {
        var updatedRecipes = filterRecipes(text: text)
        sortRecipes(sort: sortingOption, recipes: &updatedRecipes)
        return updatedRecipes
    }
}

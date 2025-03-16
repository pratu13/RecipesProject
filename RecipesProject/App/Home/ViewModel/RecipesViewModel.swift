//
//  RecipesViewModel.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Observation
import Foundation
import Swift

protocol RecipesViewModable {
    var error: Bool {get set }
    var errorString: String {get set}
    var isLoading: Bool {get set}
}

@Observable
final class RecipesViewModel: Sendable, RecipesViewModable  {
    
    private var isolationQueue: DispatchQueue = DispatchQueue(label: "com.recipes", attributes: .concurrent)
    private(set) var recipes: [Recipe] = []
    private(set) var filtered: [Recipe] = []
    internal var error: Bool = false
    internal var errorString: String = ""
    internal var isLoading: Bool = false
    var endpoint: RecipesEndpoint = .init(type: .allRecipes) {
        didSet {
            Task {
                await getAllRecipes()
            }
        }
    }
    
    var searchText: String = "" {
        didSet {
            if (!searchText.isEmpty) {
                filterRecipes(text: searchText, startingRecipes: recipes)
            }
        }
    }

    func getAllRecipes() async {
        isolationQueue.async(flags: .barrier) {
            self.recipes.removeAll()
            self.isLoading = true
        }
        do {
            let result = await NetworkingManager.downloadData(from: endpoint)
            switch result {
            case .success(let recipes):
                let decodedData = try JSONDecoder().decode(Recipes.self, from: recipes)
                await MainActor.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    isolationQueue.async(flags: .barrier) {
                        self.isLoading = false
                        self.error = false
                    }
                    self.recipes = decodedData.recipes
                }
            case .failure(let failure):
                isolationQueue.async(flags: .barrier) {
                    self.isLoading = false
                    self.errorString = failure.localizedDescription
                    self.error = true
                }
            }
        } catch (let err) {
            isolationQueue.async(flags: .barrier) {
                self.isLoading = false
                self.errorString = err.localizedDescription
                self.error = true
            }
        }
    }
    
}

//MARK: - helpers
extension RecipesViewModel {
    
    var loading: Bool {
        isolationQueue.sync {
            self.isLoading
        }
    }
 
    
    var errorDownloading: Bool {
        isolationQueue.sync {
            self.error
        }
    }
    
    var errorDescription: String {
        isolationQueue.sync {
            self.errorString
        }
    }
    
    func setMock() {
        recipes.append(Recipe.mock)
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

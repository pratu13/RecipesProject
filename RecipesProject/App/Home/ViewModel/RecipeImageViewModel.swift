//
//  CoinImageViewModel.swift
//  RecipesProject
//
//  Created by Pratyush on 3/12/25.
//


import SwiftUI
import Observation

enum ImageSize {
    case small, large
}

@Observable
class RecipeImageViewModel {
    
    var image: Image? = nil
    var isLoading: Bool = false
    var imageSize: ImageSize
    
    init(size: ImageSize) {
        self.imageSize = size
        self.isLoading = true
    }
    
    /// donwloads and caches the image for a given recupe
    /// - Parameter recipe: Recipe for which the image is being downloaded
    func getImage(for recipe: Recipe) async {
        let data = await RecipeImageService.downloaImage(for: recipe, of: imageSize)
        switch data {
        case .success(let success):
            await MainActor.run {
                self.isLoading = false
                self.image = Image(uiImage: success) 
                print("succssfully downloaed: \(recipe.name)")
            }
        case .failure(let failure):
            await MainActor.run {
                self.isLoading = false
                print("failed downloaed: \(recipe.name)")
            }
        }
    }
}

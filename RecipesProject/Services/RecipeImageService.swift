//
//  RecipeImageService.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Foundation
import SwiftUI

protocol ImageCache {
    associatedtype CachedImage
    func image(for id: NSString) -> CachedImage?
    func insertImage(_ image: CachedImage?, for id: NSString)
}

@Observable
class RecipeImageService<Cache: ImageCache> where Cache.CachedImage == UIImage {
    
    private let cache: Cache
    var image: UIImage? = nil
    private let recipe: Recipe
 
    init(recipe: Recipe, cache: Cache) {
        self.recipe = recipe
        self.cache = cache
    }

    func downloadRecipeImage() async {
        guard let url = URL(string: recipe.photo_url_small) else { print("Error")
            return }
        
        if let cachedImage = cache.image(for: NSString(string: recipe.uuid)) {
            self.image = cachedImage
            return
        }
        
        Task { [weak self] in
            guard let self = self else { return }
            let data = await NetworkingManager.downloadData(from: .init(type: .imageSmall(url.absoluteString)))
            
            switch data {
            case .success(let success):
                guard let downloadedImage = UIImage(data: success) else {
                    print("Invalid image data")
                    return
                }
                await MainActor.run {
                    self.image = downloadedImage
                    self.cache.insertImage(downloadedImage, for: NSString(string: self.recipe.uuid))
                }
            case .failure(let failure):
                print("Error downloading image: \(failure)")
            }
        }
    }
}

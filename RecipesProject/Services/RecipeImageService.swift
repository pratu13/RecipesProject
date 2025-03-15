//
//  RecipeImageService.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Foundation
import SwiftUI

enum ImageDownloadError: Error {
     case urlIssue
     case downloadFailed
     case invalidData
}

actor RecipeImageService {
    
    private static let cache = NSImageCache()
    var image: UIImage? = nil

    private init() { }

    static func downloaImage(for recipe: Recipe, of size: ImageSize) async -> Result<UIImage, ImageDownloadError> {
        guard let largeImageURL = recipe.photo_url_large, let smallImageURL = recipe.photo_url_small else {
            return .failure(.urlIssue)
        }
        guard let url = URL(string: size == .large ? largeImageURL : smallImageURL) else {
            print("Error")
            return .failure(.urlIssue)
        }
        
        if let cachedImage = self.cache.image(for: NSString(string: recipe.uuid)) {
            return .success(cachedImage)
        }
        
        let data = await NetworkingManager.downloadData(from: .init(type: .image(url.absoluteString)))
        
        switch data {
        case .success(let success):
            guard let downloadedImage = UIImage(data: success) else {
                print("Invalid image data")
                return .failure(.invalidData)
            }
            
            self.cache.insertImage(downloadedImage, for: NSString(string: recipe.uuid))
            return .success(downloadedImage)
        case .failure(_):
            return .failure(.downloadFailed)
        }
    }
}

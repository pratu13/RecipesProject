//
//  Recipe.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Foundation

struct Recipes: Codable {
    let recipes: [Recipe]
}

struct Recipe : Codable, Hashable {
    let cuisine : String
    let name : String
    let photo_url_large : String?
    let photo_url_small : String?
    let source_url : String?
    let uuid : String
    let youtube_url : String?
    
    enum CodingKeys: String, CodingKey {
        
        case cuisine = "cuisine"
        case name = "name"
        case photo_url_large = "photo_url_large"
        case photo_url_small = "photo_url_small"
        case source_url = "source_url"
        case uuid = "uuid"
        case youtube_url = "youtube_url"
    }
}

extension Recipe {
    static var mock: Recipe {
        let recipe = Recipe(cuisine: "American",
                             name: "Choc Chip Pecan Pie",
                             photo_url_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/54462bd7-afc2-43aa-a10e-3ddd0a829954/large.jpg",
                             photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/54462bd7-afc2-43aa-a10e-3ddd0a829954/small.jpg",
                             source_url: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie",
                             uuid: "6a3f96c1-02db-412a-ab7c-bb69b1bb4a8a",
                             youtube_url: "https://www.youtube.com/watch?v=fDpoT0jvg4Y")
        return recipe
    }
    static var mock2: Recipe {
        let recipe = Recipe(cuisine: "American",
                             name: "Choc Chip Pecan Pie",
                             photo_url_large: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/54462bd7-afc2-43aa-a10e-3ddd0a829954/large.jpg",
                             photo_url_small: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/54462bd7-afc2-43aa-a10e-3ddd0a829954/small.jpg",
                             source_url: "https://www.bbcgoodfood.com/recipes/choc-chip-pecan-pie",
                             uuid: "6a3f96c1-02db-412a-ab7c-bb69b1bb4a8b",
                             youtube_url: "https://www.youtube.com/watch?v=fDpoT0jvg4Y")
        return recipe
    }
}

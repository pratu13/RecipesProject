//
//  Recipe.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//


struct Recipe : Codable {
    let cuisine : String
    let name : String
    let photo_url_large : String
    let photo_url_small : String
    let source_url : String
    let uuid : String
    let youtube_url : String
    
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

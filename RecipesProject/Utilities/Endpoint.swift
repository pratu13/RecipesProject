//
//  Endpoint.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var url: URL { get }
}

extension Endpoint {
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
}

enum RecipeEndpointType {
    case allRecipes
    case malformedData
    case emptyData
    case imageLarge(String)
    case imageSmall(String)
}

struct RecipesEndpoint: Endpoint {
    let type: RecipeEndpointType
    
    var baseURL: URL {
        return URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/")!
    }
    
    var path: String {
        switch type {
        case .allRecipes:
            return "recipes.json"
        case .malformedData:
            return "recipes-malformed.json"
        case .emptyData:
            return "recipes-empty.json"
        case .imageLarge(let urlString):
            return urlString.suffix(baseURL.absoluteString.count).base
        case .imageSmall(let urlString):
            return urlString.suffix(baseURL.absoluteString.count).base
        }
    }
}

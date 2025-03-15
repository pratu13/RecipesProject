//
//  RecipesProjectTests.swift
//  RecipesProjectTests
//
//  Created by Pratyush on 3/15/25.
//

import XCTest
import SwiftUI
@testable import RecipesProject

final class RecipesProjectTests: XCTestCase {
    
    func testRecipeImageViewModelInitialization() {
        let viewModel = RecipeImageViewModel(size: .large)
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.image)
    }
    
    func testGetImageSuccess() async {
        let recipe = Recipe.mock
        let viewModel = RecipeImageViewModel(size: .large)
        
        await viewModel.getImage(for: recipe)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.image)
    }
    
    func testGetImageFailure() async {
        let recipe = Recipe(cuisine: "Test", name: "Test Recipe", photo_url_large: nil, photo_url_small: nil, source_url: nil, uuid: "test-uuid", youtube_url: nil)
        let viewModel = RecipeImageViewModel(size: .large)
        
        await viewModel.getImage(for: recipe)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.image)
    }
    
}



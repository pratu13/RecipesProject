//
//  RecipesViewModelTests.swift
//  RecipesProject
//
//  Created by Pratyush on 3/15/25.
//


import XCTest
@testable import RecipesProject

@MainActor
final class RecipesViewModelTests: XCTestCase {
    
   func testRecipesViewModelInitialization() {
        let viewModel = RecipesViewModel()
        
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertTrue(viewModel.filtered.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }
    
    func testSetMock() {
        let viewModel = RecipesViewModel()
        viewModel.setMock()
        
        XCTAssertFalse(viewModel.recipes.isEmpty)
        XCTAssertEqual(viewModel.recipes.first?.name, Recipe.mock.name)
    }
    
    func testGetAllRecipesSuccess() async {
        let viewModel = RecipesViewModel()
        
        await viewModel.getAllRecipes()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.recipes.isEmpty)
    }
    
    func testFilterRecipes() {
        let viewModel = RecipesViewModel()
        viewModel.setMock()
        
        viewModel.searchText = "Choc"
        
        XCTAssertFalse(viewModel.filtered.isEmpty)
        XCTAssertEqual(viewModel.filtered.first?.name, Recipe.mock.name)
    }
    
    func testFilterRecipesNoMatch() {
        let viewModel = RecipesViewModel()
        viewModel.setMock()
        
        viewModel.searchText = "Nonexistent"
        
        XCTAssertTrue(viewModel.filtered.isEmpty)
    }
    
    func testGetAllRecipesMalformedData() async {
        let viewModel = RecipesViewModel()
        viewModel.endpoint = RecipesEndpoint(type: .malformedData)
        
        await viewModel.getAllRecipes()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertTrue(viewModel.error)
        XCTAssertFalse(viewModel.errorString.isEmpty)
    }
    
    func testGetAllRecipesEmptyData() async {
        let viewModel = RecipesViewModel()
        viewModel.endpoint = RecipesEndpoint(type: .emptyData)
        
        await viewModel.getAllRecipes()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertFalse(viewModel.error)
    }
    
    func testGetAllRecipesNetworkError() async {
        let viewModel = RecipesViewModel()
        // Simulate network error by setting a bad URL
        viewModel.endpoint = RecipesEndpoint(type: .image("https://badURL.com"))
        
        await viewModel.getAllRecipes()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertTrue(viewModel.error)
        XCTAssertFalse(viewModel.errorString.isEmpty)
        
    }
}

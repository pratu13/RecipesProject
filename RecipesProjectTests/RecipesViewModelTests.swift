//
//  RecipesViewModelTests.swift
//  RecipesProject
//
//  Created by Pratyush on 3/15/25.
//


import XCTest
@testable import RecipesProject

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
}
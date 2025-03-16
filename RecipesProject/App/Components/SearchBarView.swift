//
//  SearchBarView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/14/25.
//

import SwiftUI

struct SearchBarView: View {
    @FocusState private var isFocused: Bool
    @Bindable var viewModel: RecipesViewModel
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor( viewModel.searchText.isEmpty ? .gray : .white)

            TextField("Search by name or cuisine...", text:  $viewModel.searchText)
                .foregroundColor(.white)
                .disableAutocorrection(true)
                .focused($isFocused)
        
        }
        .font(.headline)
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
                .padding()
                .offset(x: 10)
                .opacity( viewModel.searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    viewModel.searchText = ""
                }
            
            ,alignment: .trailing)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding()
       
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchBarView(viewModel: RecipesViewModel())
        .preferredColorScheme(.dark)
        .padding()
}

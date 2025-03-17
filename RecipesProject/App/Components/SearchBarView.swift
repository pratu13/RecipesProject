//
//  SearchBarView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/14/25.
//

import SwiftUI

struct SearchBarView: View {
    @FocusState private var isFocused: Bool
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? .gray : .white)

            TextField("Search by name or cuisine...", text:  $searchText)
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
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    searchText = ""
                }
            
            ,alignment: .trailing)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding()
       
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchBarView(searchText: .constant(""))
        .preferredColorScheme(.dark)
        .padding()
}

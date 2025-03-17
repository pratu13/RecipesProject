//
//  RecipeDetailView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/12/25.
//

import SwiftUI
import MediaPlayer

struct RecipeDetailView: View {
    var recipe: Recipe
    @State private var showSafari = false
    @Binding var showDetail: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                RecipeImageView(recipe: recipe)
                    .frame(maxWidth: .infinity)
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .overlay(alignment: .topLeading) {
                        HStack {
                            closeButton
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                
                recipeTitle
            
                HStack {
                    cuisineSection
                    if let _ = recipe.source_url {
                        sourceSection
                    }
                }
                youtubeSection
                
                Spacer()
                
            }
            .sheet(isPresented: $showSafari) {
                if let sourceUrl = URL(string: recipe.source_url ?? "") {
                    SafariView(url: sourceUrl)
                        .ignoresSafeArea()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RecipeDetailView(recipe: .mock, showDetail: .constant(true))
}
    
//MARK: - Privat members
extension RecipeDetailView {
    
    var recipeTitle: some View {
        Text(recipe.name)
            .padding(12)
            .font(.custom(.heavy, relativeTo: .title3))
            .foregroundStyle(Color.black)
            .background(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(20)
    }
    
    var cuisineSection: some View {
        Text("This is \(recipe.cuisine.withIndefiniteArticle) cuisine.")
            .font(.custom(.regular, relativeTo: .body))
            .foregroundStyle(.white)
    }
    
    var sourceSection: some View {
        HStack(spacing: 0) {
            Text("Read more")
                .foregroundStyle(.white)
                .font(.custom(.regular, relativeTo: .body))
            Button {
                showSafari = true
            } label: {
                Text("here")
                    .font(.custom(.bold, relativeTo: .body))
                    .italic()
                    .padding(12)
                    .foregroundStyle(Color.yellow)
            }
        }
    }
    
    var closeButton: some View {
        HStack {
            Button(action: {
                showDetail = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.yellow)
                    .font(.largeTitle)
                    .padding()
            }
            Spacer()
        }
        .safeAreaPadding(.top, 44)
    }
    
    @ViewBuilder
    var youtubeSection: some View {
        if let youtubeURL = URL(string: recipe.youtube_url ?? "") {
            Link(destination: youtubeURL) {
                Label("Watch Recipe Video", systemImage: "play.circle.fill")
                    .font(.headline)
                    .foregroundColor(.yellow)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.red.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        } else {
            EmptyView()
        }
    }
}

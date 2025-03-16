//
//  RecipesHomeView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import SwiftUI

struct RecipesHomeView: View {
    @Environment(RecipesViewModel.self) var viewModel
    var backgroundImageViewModel: RecipeImageViewModel =  RecipeImageViewModel(size: .large)
    @State private var selectedRecipe: Recipe = .mock
    
    @State private var isAnimating = false
    @State var showDetail: Bool = false
    @State var animateButton: Bool = false
    @State var showErrorView: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                Color.black
                    .ignoresSafeArea()
                ZStack(alignment: .top) {
                    backgroundImage
        
                    HStack(spacing: 5) {
                        SearchBarView(viewModel: viewModel)
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.gray.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture {
                                viewModel.endpoint = .init(type: .allRecipes)
                            }
                        Spacer()
                    }
                }
                VStack {
                    recipeInfoSection
                    recipeListSection
                }
               
                .animation(.default, value: selectedRecipe)
               
            }
            .fullScreenCover(isPresented: $showDetail) {
                RecipeDetailView(recipe: selectedRecipe,
                                 showDetail: $showDetail)
            }
            .onAppear {
                print("RecipesHomeView onAppear")
            }
            
            if (showErrorView) {
                ZStack {
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                    ErrorView(errorDescription: viewModel.errorDescription)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .scale))
                }
                .animation(.easeInOut, value: viewModel.error)
            }
        }
        .task {
            await viewModel.getAllRecipes()
        }
        .task {
            await backgroundImageViewModel.getImage(for: selectedRecipe)
        }
        .onChange(of: viewModel.errorDownloading) { oldValue, newValue in
            showErrorView = newValue
        }
    }
    
}

//MARK: - Private members
private extension RecipesHomeView {
    
    var backgroundImage: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                if let image = backgroundImageViewModel.image {
                    image
                        .resizable()
                        .clipped()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .onAppear {
                            print("Loading image for recipe: \(selectedRecipe.name)")
                        }
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                            .tint(.white)
                        Spacer()
                    }
                    
                }
                
                Spacer()
            }
        }
        .scaleEffect(isAnimating ? 1.1 : 1.0)
        .offset(x: isAnimating ? 20 : 0, y: isAnimating ? -20 : 20)
        .animation(
            .easeInOut(duration: 10)
            .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
            print("Background image onAppear")
        }
        .overlay(Color.black.opacity(0.3))
        .ignoresSafeArea()
       
    }
    var recipeInfoSection: some View {
        VStack(spacing: 10) {
            Spacer()
            recipeName
            seeMoreButton
            Spacer()
        }
    }
    
    var recipeName: some View {
        HStack {
            Text(selectedRecipe.name)
                .font(.custom(.regular, relativeTo: .largeTitle))
                .foregroundStyle(Color.white)
                .lineLimit(3)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var seeMoreButton: some View {
        HStack {
            Button {
                showDetail = true
            } label: {
                Text("See More")
                    .foregroundStyle(Color.white)
                    .font(.custom(.black, relativeTo: .body))
                    .padding()
                    .background(Color.yellow)
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            .scaleEffect(animateButton ? 1.1 : 1.0)
            .animation(.spring(), value: animateButton)
            .onChange(of: selectedRecipe, { _, newValue in
                Task {
                    
                    await backgroundImageViewModel.getImage(for: newValue)
                }
                animate()
            })
            Spacer()
        }
    }
    
    var recipeListSection: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(!viewModel.searchText.isEmpty ? "Searching ..." : "Trending Recipes")
                .font(.custom(.heavy, relativeTo: .title3))
                .padding(.horizontal, 16)
                .foregroundStyle(Color.white)
            if viewModel.loading {
                HStack{
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                }
             
            } else if (viewModel.filtered.isEmpty && viewModel.recipes.isEmpty) {
                noResultsView
            } else if (!viewModel.searchText.isEmpty && viewModel.filtered.isEmpty) {
                noResultsView
            }
            else {
                recipeList
            }
            Spacer()
        }
        .frame(maxHeight: UIScreen.main.bounds.height / 3)
        .padding(.bottom)
    }
    
    var recipeList: some View {
        CarousalView(recipes: viewModel.searchText.isEmpty ? viewModel.recipes : viewModel.filtered) { recipes in
            ForEach(recipes, id: \.uuid) { recipe in
                RecipeRowView(recipe: recipe)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedRecipe = recipe
                    }
            }
        }
    }
    
    var noResultsView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("No results found. Try Again")
                    .font(.custom(.heavy, relativeTo: .caption2))
                    .foregroundStyle(.white)
                if (viewModel.searchText.isEmpty) {
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            viewModel.endpoint = .init(type: .allRecipes)
                        }
                }
                Spacer()
               
            }
            Spacer()
        }
    }
    
}

//MARK: - Private methods
private extension RecipesHomeView {
    
    func animate() {
        animateButton = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animateButton = false
        }
    }
}

#Preview {
    RecipesHomeView()
        .environment(RecipesViewModel())
}


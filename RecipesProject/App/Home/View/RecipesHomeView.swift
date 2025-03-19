//
//  RecipesHomeView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/11/25.
//

import SwiftUI
import TipKit

struct RecipesHomeView: View {
    @State private var viewModel = RecipesViewModel()
    @Environment(NetworkMonitor.self) var networkMonitor
    
    @State private var backgroundImageViewModel: RecipeImageViewModel = RecipeImageViewModel(size: .large)
    @State private var selectedRecipe: Recipe? = nil
    @State private var isAnimating = false
    @State private var animateButton: Bool = false
    @State private var sortOption: SortOption = .name
    @State var showDetail: Bool = false
   
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                Color.black
                    .ignoresSafeArea()
                ZStack(alignment: .top) {
                    backgroundImage
        
                    HStack(spacing: 5) {
                        SearchBarView(searchText: $viewModel.searchText)
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
                if let backgroundImage = backgroundImageViewModel.image, let selectedRecipe = selectedRecipe {
                    RecipeDetailView(recipe: selectedRecipe, backgroundImage: backgroundImage,
                                     showDetail: $showDetail)
                }
               
            }
            .onAppear {
                print("RecipesHomeView onAppear")
            }
            
            if (!networkMonitor.isConnected || viewModel.error || selectedRecipe == nil) {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                        .transition(.asymmetric(insertion: .scale, removal: .scale))
                        .animation(.easeInOut, value: viewModel.error)
                    ErrorView(viewModel: viewModel)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .scale))
                        .animation(.easeInOut, value: viewModel.error)
                }
                .animation(.easeInOut, value: viewModel.error)
            }
        }
        .task {
            print("GET")
            await viewModel.getAllRecipes()
        }
        .task {
            print("GETIMAGE")
            if let selectedRecipe = selectedRecipe {
                getBackgroundImage(for: selectedRecipe)
            }
           
        }
        .onChange(of: networkMonitor.isConnected) { _, newValue in
            if (newValue) {
                Task {
                    print("INTERNET GET")
                    await viewModel.getAllRecipes()
                }
            }
        }
        .onChange(of: viewModel.selectedRecipe!) { _, newValue in
            selectedRecipe = newValue
            getBackgroundImage(for: newValue)
         
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
                            print("Loading image for recipe: \(selectedRecipe?.name ?? "not set")")
                        }
                } else {
                    ZStack {
                        Image("bg")
                            .resizable()
                            .clipped()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        HStack {
                            Spacer()
                            ProgressView()
                                .tint(.white)
                            Spacer()
                        }
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
            if let _ = selectedRecipe {
                seeMoreButton
            }
            Spacer()
        }
    }
    
    var recipeName: some View {
        HStack {
            if let selectedRecipe = selectedRecipe {
                Text(selectedRecipe.name)
                    .font(.custom(.regular, relativeTo: .largeTitle))
                    .foregroundStyle(Color.white)
                    .lineLimit(3)
            }
           
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
            .onChange(of: selectedRecipe ?? .mock, { _, newValue in
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
            HStack(spacing: 4.0) {
                Text(!viewModel.searchText.isEmpty ? "Searching ..." : "Trending Recipes")
                    .font(.custom(.heavy, relativeTo: .title3))
                    .padding(.horizontal, 16)
                    .foregroundStyle(Color.white)
                HStack {
                   
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                        .frame(width: 24, height: 24)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .rotationEffect(Angle(degrees: (viewModel.sortOption == .name || viewModel.sortOption == .cuisine ) ?  0.0 : 180.0))
                        .onTapGesture {
                            withAnimation {
                                sortOption = viewModel.sortWith(option: sortOption)
                            }
                        }
                       
                    Text(sortOption.title)
                        .foregroundStyle(.white)
                        .font(.custom(.demibold, relativeTo: .callout))
                }
                .contextMenu {
                    contextMenuOptions
                }
                Spacer()
            }
            
    
            if (viewModel.isLoading) {
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
        CarousalView(recipes: viewModel.searchText.isEmpty ?  viewModel.recipes : viewModel.filtered) { recipes in
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
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .onTapGesture {
                            viewModel.endpoint = .init(type: .allRecipes)
                        }
                }
                Spacer()
               
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    var contextMenuOptions: some View {
        ForEach([SortOption.name, SortOption.cuisine], id:\.self) { option in
            Button {
                sortOption = option
                viewModel.sortOption = sortOption
            } label: {
                Text(option.rawValue.capitalized)
                    .foregroundStyle(.black)
                    .font(.custom(.demibold, relativeTo: .callout))
            }

           
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
    
    func getBackgroundImage(for recipe: Recipe) {
        Task {
            await backgroundImageViewModel.getImage(for: recipe)
        }
    }
}

#Preview {
    RecipesHomeView()
        .environment(NetworkMonitor())
}


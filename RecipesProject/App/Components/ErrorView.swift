//
//  ErrorView.swift
//  RecipesProject
//
//  Created by Pratyush on 3/16/25.
//

import SwiftUI

struct ErrorView: View {
    @Bindable var viewModel: RecipesViewModel
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Opps something went wrong")
                    .font(.custom(.heavy, relativeTo: .headline))
                    .foregroundStyle(.black)
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
            Text(!viewModel.errorString.isEmpty ? viewModel.errorString : "Please check network")
                .foregroundStyle(.red)
                .font(.custom(.medium, relativeTo: .body))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                
            Spacer()
            Button {
                Task.detached {
                    await viewModel.getAllRecipes()
                }
            } label: {
                Label(title: {
                    Text("Reload")
                        .foregroundStyle(.black)
                        .font(.custom(.bold, relativeTo: .headline))
                }, icon: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                })
                .padding()
                .background(Color.yellow)
                .clipShape(Capsule())
                
            }

        }
        .padding()
        .frame(height: UIScreen.main.bounds.height / 3)
        .frame(width: UIScreen.main.bounds.width - 64)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10, y: 10)
        
        
        
    }
}


#Preview {
    ErrorView(viewModel: RecipesViewModel())
}

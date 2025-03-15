//
//  MenuData.swift
//  Recipeapp
//
//  Created by Ak B on 2/14/25.
//

import Foundation
import SwiftUI

struct Menu: Codable {
    let recipes: [MenuData]
}

struct MenuData: Codable, Identifiable {
    var id: String { uuid }
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String?
    let uuid: String
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case uuid
        case youtubeUrl = "youtube_url"
    }
}

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @State private var selectedCuisine = "American"
    @State private var searchText = ""
    
    // Filter recipes based on cuisine and search text.
    var filteredDishes: [MenuData] {
        viewModel.dishes.filter { dish in
            dish.cuisine == selectedCuisine &&
            (searchText.isEmpty || dish.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Horizontal cuisine tab bar.
                CuisineBar(selectedTab: $selectedCuisine)
                
                if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                } else if filteredDishes.isEmpty {
                    Spacer()
                    Text("No recipes available for \(selectedCuisine).")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(filteredDishes) { dish in
                                VStack(spacing: 14) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 14) {
                                            Text(dish.name)
                                                .font(.system(size: 24, weight: .semibold))
                                                .padding(.top)
                                            
                                            // Recipe and YouTube links.
                                            if let sourceUrl = dish.sourceUrl,
                                               let url = URL(string: sourceUrl) {
                                                Link(destination: url) {
                                                    HStack {
                                                        Image(systemName: "list.clipboard.fill")
                                                        Text("View Recipe")
                                                    }
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                            }
                                            if let youtubeUrl = dish.youtubeUrl,
                                               let url = URL(string: youtubeUrl) {
                                                Link(destination: url) {
                                                    HStack {
                                                        Image(systemName: "play.circle")
                                                        Text("Video Guide")
                                                    }
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        ZStack(alignment: .trailing) {
                                            if let imageURL = URL(string: dish.photoUrlSmall) {
                                                CachedAsyncImage(url: imageURL)
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                            }
                                        }
                                    }
                                    Divider()
                                }
                                .padding(.horizontal)
                            }
                        }
                        Spacer()
                    }
                    .refreshable {
                        await viewModel.fetchData()
                    }
                }
            }
            //.navigationTitle("Recipes")
            .searchable(text: $searchText, prompt: "Search Recipes")
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

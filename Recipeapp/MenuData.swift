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
    @State private var dishes = [MenuData]()
    @State private var selectedCuisine = "American"
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            // Horizontal cuisine tab bar.
            CuisineBar(selectedTab: $selectedCuisine)
            
            if let errorMessage = errorMessage {
                // If an error occurred during fetching/decoding.
                Spacer()
                Text(errorMessage)
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            } else if dishes.filter({ $0.cuisine == selectedCuisine }).isEmpty {
                // If there are no recipes available for the selected cuisine.
                Spacer()
                Text("No recipes available for \(selectedCuisine).")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                // Display recipes matching the selected cuisine
                ScrollView {
                    LazyVStack {
                        ForEach(dishes.filter { $0.cuisine == selectedCuisine }) { dish in
                            VStack(spacing: 14) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 14) {
                                        Text(dish.name)
                                            .font(.system(size: 24, weight: .semibold))
                                            .fontWeight(.semibold)
                                            .padding(.top)
                                        // Recipe and YouTube links.
                                        
                                        if let sourceUrl = dish.sourceUrl,
                                           let url = URL(string: sourceUrl) {
                                            Link(destination: url) {
                                                HStack {
                                                    Image(systemName: "list.clipboard.fill")
                                                    Text("View Recipe")
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                            }
                                        }
                                        if let youtubeUrl = dish.youtubeUrl,
                                           let url = URL(string: youtubeUrl) {
                                            Link(destination: url) {
                                                HStack {
                                                    Image(systemName: "play.circle")
                                                    Text("Video Guide")
                                                }
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                            }
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
                    await fetchData()
                }
                
            }
        }
        .task {
            await fetchData()
        }
    }
    
    @MainActor
    func fetchData() async {
        // API URL
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            print("Invalid URL")
            self.errorMessage = "Invalid URL"
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Menu.self, from: data)
            self.dishes = decodedResponse.recipes
            self.errorMessage = nil
        } catch {
            print("Error decoding or fetching recipes: \(error.localizedDescription)")
            self.errorMessage = "Failed to load recipes."
            self.dishes = []
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

//
//  APicalls.swift
//  Recipeapp
//
//  Created by Ak B on 3/15/25.
//

import Foundation
import SwiftUI

final class MenuViewModel: ObservableObject {
    @Published var dishes = [MenuData]()
    @Published var errorMessage: String? = nil
    
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

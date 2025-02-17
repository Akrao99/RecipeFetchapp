//
//  Recipelogo.swift
//  Recipeapp
//
//  Created by Ak B on 2/14/25.
//

import SwiftUI

struct RecipeLogo: View {
    var body: some View {
        HStack{
            Image("recipelogo")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text("Recipe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
        }
    }
}

struct RecipeLogo_Previews: PreviewProvider {
    static var previews: some View {
        RecipeLogo()
    }
}



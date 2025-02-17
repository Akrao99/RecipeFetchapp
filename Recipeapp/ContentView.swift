//
//  ContentView.swift
//  Recipeapp
//
//  Created by Ak B on 2/14/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        
        
        VStack {
            RecipeLogo()
                .padding(.top,35)
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            
            
            MenuView()
            
            
            Spacer()
        }
        
        .padding()
        .ignoresSafeArea(.all)
        
        
    }
}

#Preview {
    ContentView()
}

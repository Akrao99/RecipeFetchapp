//
//  MenuCuisine.swift
//  Recipeapp
//
//  Created by Ak B on 2/14/25.
//
import  SwiftUI
struct CuisineBar: View {
    
    @Binding var selectedTab: String
    var tabs = [
        "American",
        "British",
        "Canadian",
        "Croatian",
        "French",
        "Greek",
        "Italian",
        "Malaysian",
        "Polish",
        "Portuguese",
        "Russian",
        "Tunisian"
    ]
    @Namespace private var underlineNamespace
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(tabs, id: \.self) { tab in
                        Button {
                            withAnimation {
                                selectedTab = tab
                            }
                        } label: {
                            VStack {
                                Text(tab)
                                    .font(.subheadline)
                                    .foregroundStyle(selectedTab == tab ? .black : .gray)
                                    .padding(.bottom, 14)
                                    .overlay(
                                        selectedTab == tab ?
                                        Rectangle()
                                            .frame(height: 5)
                                            .foregroundStyle(.black)
                                            .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                                        : nil,alignment: .bottom)
                                
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 44, alignment: .leading)
        
        
        
    }
    
}





struct previewMenuCuisine: PreviewProvider {
    static var previews: some View {
        CuisineBar(selectedTab: .constant("American"))    }
}

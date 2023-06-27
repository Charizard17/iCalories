//
//  AddFoodView.swift
//  iCalories
//
//  Created by Esad Dursun on 23.06.23.
//

import SwiftUI

struct SearchFoodView: View {
    @State private var searchText = ""
    @State private var searchResults: [FoodItem] = []
    
    var apiController = USDAFoodAPIController()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search for food", text: $searchText, onCommit: {
                        searchFood()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        searchFood()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                List(searchResults, id: \.fdcId) { foodItem in
                    VStack(alignment: .leading) {
                        Text(foodItem.description)
                            .font(.headline)
                        if let calories = foodItem.calories {
                            Text("Calories: \(Int(calories))")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Search Food")
        }
    }
    
    private func searchFood() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        apiController.searchFoodItems(withQuery: searchText) { (foodItems, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let foodItems = foodItems {
                DispatchQueue.main.async {
                    searchResults = foodItems
                }
            }
        }
    }
}

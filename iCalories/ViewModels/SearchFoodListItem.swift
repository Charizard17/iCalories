//
//  SearchListItem.swift
//  iCalories
//
//  Created by Esad Dursun on 27.06.23.
//

import SwiftUI

struct SearchFoodListItem: View {
    
    var foodItem: FoodItem
    
    @State private var showingAddFoodView = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(foodItem.name.prefix(1).capitalized + foodItem.name.dropFirst())
                    .bold()
                Text("\(Int(foodItem.calories ?? 0))") + Text(" calories").foregroundColor(.red)
                Text("\(Int(foodItem.servingSize))") + Text(" grams").foregroundColor(.red)
                Button {
                    showingAddFoodView = true
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.clear)
                .sheet(isPresented: $showingAddFoodView) {
                    AddFoodView(optName: foodItem.name.prefix(1).capitalized + foodItem.name.dropFirst(), optGrams: foodItem.servingSize, optCalories: foodItem.calories)
                }
            }
        }
    }
}

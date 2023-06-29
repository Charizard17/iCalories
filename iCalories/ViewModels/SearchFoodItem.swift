//
//  SearchListItem.swift
//  iCalories
//
//  Created by Esad Dursun on 27.06.23.
//

import SwiftUI

struct SearchFoodItem: View {
    
    var foodItem: FoodItem
    
    @State private var showingAddFoodView = false
    
    var optRatio: Double? {
        foodItem.calories != nil && foodItem.servingSize != 0 ? foodItem.calories! / foodItem.servingSize : nil
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(foodItem.name.prefix(1).capitalized + foodItem.name.dropFirst())
                    .font(.system(size: 18))
                HStack {
                    Text("\(Int(foodItem.servingSize)) g –")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Text("\(Int(foodItem.calories ?? 0)) Kcal")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Button {
                    showingAddFoodView = true
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.teal)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.clear)
                .sheet(isPresented: $showingAddFoodView) {
                    AddFoodView(optName: foodItem.name.prefix(1).capitalized + foodItem.name.dropFirst(), optGrams: foodItem.servingSize, optCalories: foodItem.calories, optRatio: optRatio)
                }
            }
        }
    }
}

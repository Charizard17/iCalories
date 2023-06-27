//
//  SearchListItem.swift
//  iCalories
//
//  Created by Esad Dursun on 27.06.23.
//

import SwiftUI

struct SearchFoodListItem: View {
    
    var foodItem: FoodItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(foodItem.name)
                    .bold()
                HStack {
                    Text("\(Int(foodItem.calories ?? 0))") + Text(" calories").foregroundColor(.red)
                    Text("\(Int(foodItem.servingSize))") + Text(" grams").foregroundColor(.red)
                }
            }
        }
    }
}

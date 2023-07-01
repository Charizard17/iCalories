//
//  FoodItemRow.swift
//  iCalories
//
//  Created by Esad Dursun on 30.06.23.
//

import SwiftUI
import CoreData

struct FoodItemRow: View {
    let food: Food
    let favoriteFoodArray: FetchedResults<FavoriteFood>
    let managedObjectContext: NSManagedObjectContext
    
    @Binding var selectedFood: Food?
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading) {
                Text(food.name ?? "")
                    .font(.system(size: mediumFontSize))
                HStack {
                    Text("\(Int(food.grams)) g –")
                        .foregroundColor(.gray)
                        .font(.system(size: smallFontSize))
                    Text("\(Int(food.calories)) Kcal")
                        .foregroundColor(.gray)
                        .font(.system(size: smallFontSize))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(calcTimeSince(date: food.date!))
                    .foregroundColor(.gray)
                    .font(.system(size: smallFontSize))
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    Button(action: {
                        toggleFavoriteFood(name: food.name!, grams: food.grams, calories: food.calories)
                    }) {
                        Image(systemName: favoriteFoodArray.contains(where: {$0.name == food.name! && $0.grams == food.grams && $0.calories == food.calories}) ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.teal)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.clear)
                    .padding(.horizontal)
                    Button(action: {
                        selectedFood = food
                    }) {
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.teal)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.clear)
                }
            }
        }
        .padding(.vertical, 5)
    }
    
    private func toggleFavoriteFood(name: String, grams: Double, calories: Double) {
        if let favoriteFood = favoriteFoodArray.first(where: { $0.name == name && $0.grams == grams && $0.calories == calories}) {
            managedObjectContext.delete(favoriteFood)
        } else {
            DataController().addFavoriteFood(name: name, grams: grams, calories: calories, context: managedObjectContext)
        }
        DataController().save(context: managedObjectContext)
    }
}

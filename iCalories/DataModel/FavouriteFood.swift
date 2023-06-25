//
//  Food.swift
//  iCalories
//
//  Created by Esad Dursun on 24.06.23.
//

import Foundation

struct FavouriteFood: Identifiable {
    let id: Int
    let name: String
    let calories: Double
}

var favouriteFoods: [FavouriteFood] = [
    FavouriteFood(id: 1, name: "Apple", calories: 200),
    FavouriteFood(id: 2, name: "Orange", calories: 150),
    FavouriteFood(id: 3, name: "Banana", calories: 300),
    FavouriteFood(id: 4, name: "Kiwi", calories: 50),
    FavouriteFood(id: 5, name: "Watermelon", calories: 100),
    FavouriteFood(id: 6, name: "Carrot", calories: 70),
    FavouriteFood(id: 7, name: "Bread", calories: 350),
    FavouriteFood(id: 8, name: "Steak", calories: 900),
    FavouriteFood(id: 9, name: "Milk", calories: 120),
    FavouriteFood(id: 10, name: "Oatmeal", calories: 200),
]

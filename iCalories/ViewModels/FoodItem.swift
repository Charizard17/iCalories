//
//  FoodItem.swift
//  iCalories
//
//  Created by Esad Dursun on 27.06.23.
//

import Foundation

struct FoodItem: Codable, Identifiable {
    let id = UUID()
    let name: String
    let calories: Double?
    let fat: Double?
    let carbohydrates: Double?
    let protein: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case calories = "calories"
        case fat = "fat_total_g"
        case carbohydrates = "carbohydrates_total_g"
        case protein = "protein_g"
    }
}

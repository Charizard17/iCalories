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
    let servingSize: Double
    let calories: Double?
    let fatTotal: Double?
    let fatSaturated: Double?
    let protein: Double?
    let sodium: Int?
    let potassium: Int?
    let cholesterol: Int?
    let carbohydratesTotal: Double?
    let fiber: Double?
    let sugar: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case servingSize = "serving_size_g"
        case calories
        case fatTotal = "fat_total_g"
        case fatSaturated = "fat_saturated_g"
        case protein = "protein_g"
        case sodium = "sodium_mg"
        case potassium = "potassium_mg"
        case cholesterol = "cholesterol_mg"
        case carbohydratesTotal = "carbohydrates_total_g"
        case fiber = "fiber_g"
        case sugar = "sugar_g"
    }
    
    init(name: String) {
        self.name = name
        self.servingSize = 100.0
        self.calories = nil
        self.fatTotal = nil
        self.fatSaturated = nil
        self.protein = nil
        self.sodium = nil
        self.potassium = nil
        self.cholesterol = nil
        self.carbohydratesTotal = nil
        self.fiber = nil
        self.sugar = nil
    }
}

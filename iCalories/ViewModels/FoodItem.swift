//
//  FoodItem.swift
//  iCalories
//
//  Created by Esad Dursun on 27.06.23.
//

import Foundation

struct FoodItem: Codable {
    let fdcId: Int
    let description: String
    let brandOwner: String?
    let ingredients: String?
    let servingSize: Double?
    let servingSizeUnit: String?
    let calories: Double?
    
    enum CodingKeys: String, CodingKey {
        case fdcId
        case description
        case brandOwner
        case ingredients
        case servingSize
        case servingSizeUnit
        case calories
    }
}

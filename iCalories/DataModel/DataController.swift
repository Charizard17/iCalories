//
//  DataController.swift
//  iCalories
//
//  Created by Esad Dursun on 22.06.23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully!!")
        } catch {
            print("We could not save the data...")
        }
    }
    
    func addFood(date: Date, name: String, grams: Double, calories: Double, context: NSManagedObjectContext) {
        let food = Food(context: context)
        food.id = UUID()
        food.date = date
        food.name = name
        food.grams = grams
        food.calories = calories
        
        save(context: context)
    }
    
    func editFood(food: Food, date: Date, name: String, grams: Double, calories: Double, context: NSManagedObjectContext) {
        food.date = date
        food.name = name
        food.grams = grams
        food.calories = calories
        
        save(context: context)
    }
    
    func addFavoriteFood(name: String, grams: Double, calories: Double, context: NSManagedObjectContext) {
        let favoriteFood = FavoriteFood(context: context)
        favoriteFood.id = UUID()
        favoriteFood.name = name
        favoriteFood.grams = grams
        favoriteFood.calories = calories
        
        save(context: context)
    }
}

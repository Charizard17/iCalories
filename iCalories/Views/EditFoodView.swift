//
//  EditFoodView.swift
//  iCalories
//
//  Created by Esad Dursun on 23.06.23.
//

import SwiftUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var food: FetchedResults<Food>.Element
    
    @State private var name = ""
    @State private var date = Date()
    @State private var grams: Double = 0
    @State private var calories: Double = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("\(food.name!)", text: $name)
                        .font(.system(size: 20))
                        .padding(.vertical)
                        .onAppear {
                            date = food.date!
                            name = food.name!
                            grams = food.grams
                            calories = food.calories
                        }
                    VStack {
                        Text("Grams: \(Int(grams))")
                        Slider(value: $grams, in: 0...1500, step: 5)
                    }
                    .padding()
                    VStack {
                        Text("Calories: \(Int(calories))")
                        Slider(value: $calories, in: 0...1500, step: 5)
                    }
                    .padding()
                    
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date")
                    }
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            DataController().editFood(food: food, date: date, name: name, grams: grams, calories: calories, context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Food")
        }
    }
}

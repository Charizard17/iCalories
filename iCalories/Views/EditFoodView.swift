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
    @State private var calories: Double = 0
    
    var body: some View {
        Form {
            Section {
                DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                    Text("Select a date")
                }
                
                TextField("\(food.name!)", text: $name)
                    .onAppear {
                        date = food.date!
                        name = food.name!
                        calories = food.calories
                    }
                VStack {
                    Text("Calories: \(Int(calories))")
                    Slider(value: $calories, in: 0...1000, step: 10)
                }
                .padding()
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        DataController().editFood(food: food, date: date, name: name, calories: calories, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

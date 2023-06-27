//
//  AddFoodView.swift
//  iCalories
//
//  Created by Esad Dursun on 23.06.23.
//

import SwiftUI

struct AddFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var date = Date()
    @State private var calories: Double = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date")
                    }
                    
                    TextField("Food name", text: $name)
                    
                    VStack {
                        Text("Calories: \(Int(calories))")
                        Slider(value: $calories, in: 0...1000, step:10)
                    }
                    .padding()
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            DataController().addFood(date: date, name: name, calories: calories, context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Add Food")
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
    }
}

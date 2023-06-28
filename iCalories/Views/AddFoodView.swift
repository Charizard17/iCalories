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
    
    var optName: String?
    var optGrams: Double?
    var optCalories: Double?
    
    @State private var name: String
    @State private var date = Date()
    @State private var calories: Double
    @State private var grams: Double
    @State private var isNameEmptyAlertPresented = false
    
    init(optName: String?, optGrams: Double?, optCalories: Double?) {
        self.optName = optName
        self.optGrams = optGrams
        self.optCalories = optCalories
        
        _name = State(initialValue: optName ?? "")
        _calories = State(initialValue: optCalories ?? 0)
        _grams = State(initialValue: optGrams ?? 0)
    }
    
    var isNameEmpty: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Food name", text: $name)
                        .font(.system(size: 20))
                        .padding(.vertical)
                    
                    VStack {
                        Text("Grams: \(Int(grams))")
                        Slider(value: $grams, in: 0...1500, step:5)
                    }
                    .padding()
                    
                    VStack {
                        Text("Calories: \(Int(calories))")
                        Slider(value: $calories, in: 0...1500, step:5)
                    }
                    .padding()
                    
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date")
                    }
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            if isNameEmpty {
                                isNameEmptyAlertPresented = true
                            } else {
                                DataController().addFood(date: date, name: name, grams: grams, calories: calories, context: managedObjContext)
                                dismiss()
                            }
                        }
                        .disabled(calories == 0 || grams == 0)
                        .alert(isPresented: $isNameEmptyAlertPresented) {
                            Alert(title: Text("Error"), message: Text("Please enter a food name"), dismissButton: .default(Text("OK")))
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Add Food")
        }
    }
}

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
    var optRatio: Double?
    
    @State private var name: String
    @State private var date = Date()
    @State private var calories: Double
    @State private var grams: Double
    @State private var isAutoCalculateChecked: Bool
    @State private var isNameEmptyAlertPresented = false
    
    init(optName: String?, optGrams: Double?, optCalories: Double?, optRatio: Double?) {
        self.optName = optName
        self.optGrams = optGrams
        self.optCalories = optCalories
        self.optRatio = optRatio
        
        _name = State(initialValue: optName ?? "")
        _calories = State(initialValue: optCalories ?? 0)
        _grams = State(initialValue: optGrams ?? 0)
        _isAutoCalculateChecked = State(initialValue: (optGrams != nil && optCalories != nil))
    }
    
    var isNameEmpty: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Food name", text: $name)
                        .font(.system(size: largeFontSize))
                        .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("Grams: \(Int(grams))")
                        Slider(value: $grams, in: gramsSliderMin...gramsSliderMax, step: sliderStep)
                            .accentColor(.teal)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Calories: \(Int(calories))")
                            
                            if optRatio != nil && !isAutoCalculateChecked {
                                Spacer()
                                Text(manualText)
                            }
                        }
                        
                        Slider(value: $calories, in: caloriesSliderMin...caloriesSliderMax, step: sliderStep)
                            .accentColor(.teal)
                            .disabled(isAutoCalculateChecked)
                    }
                    .padding()
                    
                    if optRatio != nil {
                        Toggle(autoCalculateText, isOn: $isAutoCalculateChecked)
                            .tint(.teal)
                    }
                    
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text(selectDateText)
                    }
                    .datePickerStyle(CompactDatePickerStyle())
                    .accentColor(.teal)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if isNameEmpty {
                                isNameEmptyAlertPresented = true
                            } else {
                                DataController().addFood(date: date, name: name, grams: grams, calories: calories, context: managedObjContext)
                                dismiss()
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.teal)
                                .font(.system(size: largeFontSize))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(Color.clear)
                        .disabled(calories == 0 || grams == 0)
                        .alert(isPresented: $isNameEmptyAlertPresented) {
                            Alert(title: Text("Error"), message: Text(emptyFoodNameErrorText), dismissButton: .default(Text("OK")))
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle(addFoodViewTitle)
            .onChange(of: grams) { newValue in
                if isAutoCalculateChecked {
                    calculateCaloriesFromGrams()
                }
            }
            .modifier(DismissKeyboardModifier())
        }
    }
    
    private func calculateCaloriesFromGrams() {
        if let ratio = optRatio {
            calories = grams * ratio
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView(optName: nil, optGrams: nil, optCalories: nil, optRatio: nil)
    }
}

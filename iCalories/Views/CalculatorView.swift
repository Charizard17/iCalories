//
//  SwiftUIView.swift
//  iCalories
//
//  Created by Esad Dursun on 30.06.23.
//

import SwiftUI

struct CalculatorView: View {
    @State private var genderSelection = 0
    @State private var weight = ""
    @State private var height = ""
    @State private var age = ""
    @State private var activityLevelSelection = 0
    @State private var showInfoAlert = false
    
    let infoTitle = "BMR Calculator"
    let infoMessage = """
    This BMR Calculator estimates your Basal Metabolic Rate (BMR) and Adjusted BMR based on your personal information and activity level.
    
    BMR represents the calories your body needs at rest, while Adjusted BMR considers your activity level for a more accurate estimate.
    
    Select your gender, enter weight, height, age, and activity level to calculate BMR and Adjusted BMR.
    
    Note: Results are estimates. Consult a healthcare professional for personalized advice.
    """
    
    
    
    let activityLevels = [("Sedentary", 1.2),
                          ("Lightly Active", 1.375),
                          ("Moderately Active", 1.55),
                          ("Very Active", 1.725),
                          ("Extra Active", 1.9)]
    
    var bmr: Double {
        let weightInKg = Double(weight) ?? 0
        let heightInCm = Double(height) ?? 0
        let ageInYears = Double(age) ?? 0
        
        let bmrCalculation: Double
        
        if genderSelection == 0 { // Male
            bmrCalculation = 88.362 + (13.397 * weightInKg) + (4.799 * heightInCm) - (5.677 * ageInYears)
        } else { // Female
            bmrCalculation = 447.593 + (9.247 * weightInKg) + (3.098 * heightInCm) - (4.330 * ageInYears)
        }
        
        return bmrCalculation
    }
    
    var adjustedBMR: Double {
        let activityLevel = activityLevels[activityLevelSelection].1
        
        return bmr * activityLevel
    }
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    Picker("Gender", selection: $genderSelection) {
                        Text("Male")
                            .tag(0)
                        Text("Female")
                            .tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .accentColor(.teal)
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.numberPad)
                        .accentColor(.teal)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.numberPad)
                        .accentColor(.teal)
                }
                
                Section(header: Text("Activity Level")) {
                    Picker("Activity Level", selection: $activityLevelSelection) {
                        ForEach(0..<activityLevels.count, id: \.self) { index in
                            Text(activityLevels[index].0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Calorie Calculation")) {
                    Text("Your BMR: \(String(format: "%.2f", bmr))")
                    Text("Adjusted BMR: \(String(format: "%.2f", adjustedBMR))")
                }
            }
            .navigationTitle("BMR Calculator")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInfoAlert = true
                    }) {
                        Label("Info", systemImage: "info.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.teal)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Image(uiImage: UIImage(named: "iCaloriesLogo") ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                }
            }
            .alert(isPresented: $showInfoAlert) {
                Alert(
                    title: Text(infoTitle),
                    message: Text(infoMessage),
                    dismissButton: .default(Text("Close"))
                )
            }
            .modifier(DismissKeyboardModifier())
        }
        .accentColor(.teal)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

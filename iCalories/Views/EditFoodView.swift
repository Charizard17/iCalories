import SwiftUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var food: FetchedResults<Food>.Element
    
    @State private var name = ""
    @State private var date = Date()
    @State private var grams: Double = 0
    @State private var calories: Double = 0
    @State private var ratio: Double? = nil
    @State private var isAutoCalculateChecked = false
    @State private var isNameEmptyAlertPresented = false
    
    var isNameEmpty: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
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
                            ratio = calculatedRatio
                            isAutoCalculateChecked = (ratio != nil)
                        }
                    
                    VStack {
                        Text("Grams: \(Int(grams))")
                        Slider(value: $grams, in: 0...1000, step: 5)
                            .accentColor(.teal)
                    }
                    .padding()
                    
                    VStack {
                        HStack {
                            Text("Calories: \(Int(calories))")
                            
                            if !isAutoCalculateChecked {
                                Spacer()
                                Text("(Manual)")
                            }
                        }
                        
                        Slider(value: $calories, in: 0...2000, step: 5)
                            .accentColor(.teal)
                            .disabled(isAutoCalculateChecked)
                    }
                    .padding()
                    
                    Toggle("Auto Calculate", isOn: $isAutoCalculateChecked)
                        .tint(.teal)
                    
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date")
                    }
                    .datePickerStyle(CompactDatePickerStyle())
                    .accentColor(.teal)
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            if isNameEmpty {
                                isNameEmptyAlertPresented = true
                            } else {
                                DataController().editFood(food: food, date: date, name: name, grams: grams, calories: calories, context: managedObjContext)
                                dismiss()
                            }
                        }
                        .tint(.teal)
                        .disabled(calories == 0 || grams == 0)
                        .alert(isPresented: $isNameEmptyAlertPresented) {
                            Alert(title: Text("Error"), message: Text("Please enter a food name"), dismissButton: .default(Text("OK")))
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Food")
            .onChange(of: grams) { newValue in
                if isAutoCalculateChecked {
                    calculateCaloriesFromGrams()
                }
            }
        }
    }
    
    private func calculateCaloriesFromGrams() {
        if isAutoCalculateChecked, let ratio = ratio {
            calories = grams * ratio
        }
    }
    
    private var calculatedRatio: Double? {
        guard grams != 0 else {
            return nil
        }
        return calories / grams
    }
}

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
                            .disabled(isAutoCalculateChecked)
                    }
                    .padding()
                    
                    Toggle("Auto Calculate", isOn: $isAutoCalculateChecked)
                    
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

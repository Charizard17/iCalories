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
                        .font(.system(size: largeFontSize))
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
                        Slider(value: $grams, in: gramsSliderMin...gramsSliderMax, step: sliderStep)
                            .accentColor(.teal)
                    }
                    .padding()
                    
                    VStack {
                        HStack {
                            Text("Calories: \(Int(calories))")
                            
                            if !isAutoCalculateChecked {
                                Spacer()
                                Text(manualText)
                            }
                        }
                        
                        Slider(value: $calories, in: caloriesSliderMin...caloriesSliderMax, step: sliderStep)
                            .accentColor(.teal)
                            .disabled(isAutoCalculateChecked)
                    }
                    .padding()
                    
                    Toggle(autoCalculateText, isOn: $isAutoCalculateChecked)
                        .tint(.teal)
                    
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
                                DataController().editFood(food: food, date: date, name: name, grams: grams, calories: calories, context: managedObjContext)
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
            .navigationTitle(editFoodViewTitle)
            .onChange(of: grams) { newValue in
                if isAutoCalculateChecked {
                    calculateCaloriesFromGrams()
                }
            }
            .modifier(DismissKeyboardModifier())
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

struct EditFoodView_Previews: PreviewProvider {
    static var previews: some View {
        EditFoodView(food: Food() as FetchedResults<Food>.Element)
    }
}

//
//  ContentView.swift
//  iCalories
//
//  Created by Esad Dursun on 22.06.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    
    @State private var showingAddView = false
    @State private var showingSearchView = false
    
    var apiController = USDAFoodAPIController()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(favouriteFoods) { food in
                            VStack {
                                Button("\(food.name)") {
                                    DataController().addFood(date: Date(), name: food.name, calories: food.calories, context: managedObjContext)
                                    // Here, you can also call the API controller to retrieve additional food information
                                    apiController.searchFoodItems(withQuery: food.name) { (foodItems, error) in
                                        if let error = error {
                                            print("Error: \(error)")
                                            return
                                        }
                                        
                                        if let foodItems = foodItems, let firstFoodItem = foodItems.first {
                                            // Use the retrieved food item's information, e.g., serving size, additional details
                                            print("Serving Size: \(Int(firstFoodItem.servingSize!) )\(firstFoodItem.servingSizeUnit ?? "")")
                                            print("Ingredients: \(firstFoodItem.ingredients ?? "")")
                                            print("Calories: \(firstFoodItem.calories ?? 0) Kcal")
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                                Text("\(Int(food.calories)) Kcal")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                }
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.name!)
                                        .bold()
                                    Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
            }
            .navigationTitle("iCalories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSearchView.toggle()
                    } label: {
                        Label("Search Food", systemImage: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingSearchView) {
                SearchFoodView()
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalCaloriesToday() -> Double {
        var caloriesToday: Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        return caloriesToday
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

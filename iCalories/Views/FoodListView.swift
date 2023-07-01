//
//  ContentView.swift
//  iCalories
//
//  Created by Esad Dursun on 22.06.23.
//

import SwiftUI
import CoreData

struct FoodListView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var foodArray: FetchedResults<Food>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteFood.name, ascending: true)]) var favoriteFoodArray: FetchedResults<FavoriteFood>
    
    var apiController = FoodAPIController()
    
    @State private var showingAddFoodView = false
    @State private var showingSearchFoodView = false
    @State private var selectedFood: Food? = nil
    
    private var groupedFoodArray: [(Date, [Food])] {
        Dictionary(grouping: foodArray, by: { Calendar.current.startOfDay(for: $0.date!) })
            .sorted(by: { $0.0 > $1.0 })
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemTeal]
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if favoriteFoodArray.isEmpty == false {
                    VStack {
                        Divider()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(favoriteFoodArray) { favFood in
                                    VStack(spacing: 5) {
                                        Button(action: {
                                            DataController().addFood(date: Date(), name: favFood.name!, grams: favFood.grams, calories: favFood.calories, context: managedObjContext)
                                        }) {
                                            Text(favFood.name!)
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 5)
                                                .background(Color.teal)
                                                .cornerRadius(8)
                                                .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                                                .frame(maxWidth: 150)
                                        }
                                        .frame(maxWidth: 150)
                                        
                                        Text("\(Int(favFood.grams)) g")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                        Text("\(Int(favFood.calories)) Kcal")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                List {
                    if groupedFoodArray.count == 0 {
                        VStack(alignment: .trailing) {
                            Text("Today: 0 g – 0 Kcal")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    } else {
                        ForEach(groupedFoodArray, id: \.0) { date, foodItems in
                            Section(header: Text(dateHeader(for: date))) {
                                ForEach(foodItems) { food in
                                    FoodItemRow(food: food, favoriteFoodArray: favoriteFoodArray, managedObjectContext: managedObjContext, selectedFood: $selectedFood)
                                        .padding(.vertical, 5)
                                        .swipeActions(
                                            edge: .trailing,
                                            allowsFullSwipe: false,
                                            content: {
                                                Button(action: {
                                                    deleteFood(food: food)
                                                }, label: {
                                                    Image(systemName: "trash")
                                                })
                                                .tint(.red)
                                            }
                                        )
                                }
                            }
                            .textCase(nil)
                        }
                    }
                }
            }
            .navigationTitle("iCalories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddFoodView.toggle()
                    } label: {
                        Label("Add Food", systemImage: "plus.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.teal)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSearchFoodView.toggle()
                    } label: {
                        Label("Search Food", systemImage: "magnifyingglass")
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
            .sheet(isPresented: $showingSearchFoodView) {
                SearchFoodView()
            }
            .sheet(item: $selectedFood) { food in
                EditFoodView(food: food)
            }
            .sheet(isPresented: $showingAddFoodView) {
                AddFoodView(optName: nil, optGrams: nil, optCalories: nil, optRatio: nil)
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.teal)
        .background(Color.red)
        .font(.system(size: 17, weight: .regular))
    }
    
    private func deleteFood(food: Food) {
        withAnimation {
            managedObjContext.delete(food)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func totalGrams(for date: Date) -> Double {
        foodArray
            .filter { Calendar.current.isDate($0.date!, inSameDayAs: date) }
            .reduce(0) { $0 + $1.grams }
    }
    
    private func totalCalories(for date: Date) -> Double {
        foodArray
            .filter { Calendar.current.isDate($0.date!, inSameDayAs: date) }
            .reduce(0) { $0 + $1.calories }
    }
    
    private func dateHeader(for date: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(date) {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return "Today: \(localizedGramsAndCalories(for: date))"
        } else if calendar.isDateInYesterday(date) {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return "Yesterday: \(localizedGramsAndCalories(for: date))"
        } else {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let localizedDate = dateFormatter.string(from: date)
            return "\(localizedDate): \(localizedGramsAndCalories(for: date))"
        }
    }
    
    private func localizedGramsAndCalories(for date: Date) -> String {
        let totalGrams = Int(self.totalGrams(for: date))
        let totalCalories = Int(self.totalCalories(for: date))
        
        let gramsFormat = NumberFormatter()
        gramsFormat.numberStyle = .decimal
        let localizedGrams = gramsFormat.string(from: NSNumber(value: totalGrams)) ?? ""
        
        let caloriesFormat = NumberFormatter()
        caloriesFormat.numberStyle = .decimal
        let localizedCalories = caloriesFormat.string(from: NSNumber(value: totalCalories)) ?? ""
        
        return "\(localizedGrams) g, \(localizedCalories) Kcal"
    }
    
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = DataController().container.viewContext
        let food = Food(context: context)
        food.name = "Apple"
        food.grams = 200
        food.calories = 100
        
        return FoodListView()
            .environment(\.managedObjectContext, context)
    }
}

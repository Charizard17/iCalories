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
                    VStack(alignment: .trailing) {
                        Text("Today: \(Int(totalGramsToday)) g – \(Int(totalCaloriesToday)) Kcal")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                    }
                    
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
                                                deleteFood(offsets: IndexSet([foodItems.firstIndex(of: food)!]))
                                            }, label: {
                                                Image(systemName: "trash")
                                            })
                                            .tint(.red)
                                        }
                                    )
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
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let food = foodArray[index]
                managedObjContext.delete(food)
            }
            DataController().save(context: managedObjContext)
        }
    }
    
    private var totalGramsToday: Double {
        foodArray.reduce(0) { result, food in
            if Calendar.current.isDateInToday(food.date!) {
                return result + food.grams
            }
            return result
        }
    }
    
    private var totalCaloriesToday: Double {
        foodArray.reduce(0) { result, food in
            if Calendar.current.isDateInToday(food.date!) {
                return result + food.calories
            }
            return result
        }
    }
    
    private func dateHeader(for date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        }
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

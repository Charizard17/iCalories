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
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var foodArray: FetchedResults<Food>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteFood.name, ascending: true)]) var favoriteFoodArray: FetchedResults<FavoriteFood>
    
    @State private var showingAddFoodView = false
    @State private var showingSearchFoodView = false
    @State private var selectedFood: Food? = nil
    
    var apiController = FoodAPIController()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalGramsToday)) g (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Text("\(Int(totalCaloriesToday)) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
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
                                                .foregroundColor(.black)
                                                .font(.system(size: 15))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 5)
                                                .background(Color.white)
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
                        Divider()
                    }
                }
                List {
                    ForEach(foodArray) { food in
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading) {
                                Text(food.name ?? "")
                                    .font(.system(size: 18))
                                HStack {
                                    Text("\(Int(food.grams)) g –")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                    Text("\(Int(food.calories)) Kcal")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(calcTimeSince(date: food.date!))
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                                HStack(alignment: .firstTextBaseline) {
                                    Spacer()
                                    Button(action: {
                                        toggleFavoriteFood(name: food.name!, grams: food.grams, calories: food.calories)
                                    }) {
                                        Image(systemName: favoriteFoodArray.contains(where: {$0.name == food.name!}) ? "star.fill" : "star")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.orange)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .background(Color.clear)
                                    .padding(.horizontal)
                                    Button(action: {
                                        selectedFood = food
                                    }) {
                                        Image(systemName: "pencil")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .background(Color.clear)
                                    .sheet(item: $selectedFood) { food in
                                        EditFoodView(food: food)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        
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
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSearchFoodView.toggle()
                    } label: {
                        Label("Search Food", systemImage: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingSearchFoodView) {
                SearchFoodView()
            }
            .sheet(isPresented: $showingAddFoodView) {
                AddFoodView(optName: nil, optGrams: nil, optCalories: nil, optRatio: nil)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { foodArray[$0] }.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func toggleFavoriteFood(name: String, grams: Double, calories: Double) {
        if let favoriteFood = favoriteFoodArray.first(where: { $0.name == name }) {
            managedObjContext.delete(favoriteFood)
        } else {
            DataController().addFavoriteFood(name: name, grams: grams, calories: calories, context: managedObjContext)
        }
        DataController().save(context: managedObjContext)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) var favoriteFood: FetchedResults<FavoriteFood>
    
    @State private var showingAddFoodView = false
    @State private var showingSearchFoodView = false
    @State private var showingEditFoodView = false
    
    var apiController = FoodAPIController()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Text("\(Int(totalGramsToday())) g (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                if favoriteFood.isEmpty == false {
                    VStack {
                        Divider()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(favoriteFood) { favFood in
                                    VStack {
                                        Button("\(favFood.name!)") {
                                            DataController().addFood(date: Date(), name: favFood.name!, grams: favFood.grams, calories: favFood.calories, context: managedObjContext)
                                        }
                                        .foregroundColor(.black)
                                        Text("\(Int(favFood.calories)) Kcal")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12))
                                        Text("\(Int(favFood.grams)) g")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 12))
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                List {
                    ForEach(food) { food in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(food.name!)
                                    .bold()
                                Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.red)
                                Text("\(Int(food.grams))") + Text(" grams").foregroundColor(.red)
                            }
                            Spacer()
                            Text(calcTimeSince(date: food.date!))
                                .foregroundColor(.gray)
                                .italic()
                            Button {
                                addFavoriteFood(name: food.name!, grams: food.grams, calories: food.calories)
                            } label: {
                                Image(systemName: favoriteFood.contains(where: {$0.name == food.name!}) == false ? "star" : "star.fill")
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                            Button {
                                showingEditFoodView = true
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(Color.clear)
                            .sheet(isPresented: $showingEditFoodView) {
                                EditFoodView(food: food)
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
                AddFoodView(optName: nil, optGrams: nil, optCalories: nil)
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
    
    private func addFavoriteFood(name: String, grams: Double, calories: Double) {
        withAnimation {
            if favoriteFood.contains(where: {$0.name == name}) {
                favoriteFood.filter{$0.name == name}.forEach(managedObjContext.delete)
                DataController().save(context: managedObjContext)
            } else {
                DataController().addFavoriteFood(name: name, grams: grams, calories: calories, context: managedObjContext)
            }
        }
        print("add favorite food")
    }
    
    private func totalGramsToday() -> Double {
        var gramsToday: Double = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                gramsToday += item.grams
            }
        }
        return gramsToday
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

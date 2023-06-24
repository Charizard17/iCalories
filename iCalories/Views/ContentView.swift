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
    
    var favourites: [FavouriteFood] = [
        FavouriteFood(id: 1, name: "Apple", calories: 200),
        FavouriteFood(id: 2, name: "Orange", calories: 150),
        FavouriteFood(id: 3, name: "Banana", calories: 300),
        FavouriteFood(id: 4, name: "Kiwi", calories: 50),
        FavouriteFood(id: 5, name: "Watermelon", calories: 100),
        FavouriteFood(id: 6, name: "Carrot", calories: 70),
        FavouriteFood(id: 7, name: "Bread", calories: 350),
        FavouriteFood(id: 8, name: "Steak", calories: 900),
        FavouriteFood(id: 9, name: "Milk", calories: 120),
        FavouriteFood(id: 10, name: "Oatmeal", calories: 200),
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(favourites) { favourite in
                            Button("\(favourite.name)") {
                                DataController().addFood(date: Date(), name: favourite.name, calories: favourite.calories, context: managedObjContext)
                            }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
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

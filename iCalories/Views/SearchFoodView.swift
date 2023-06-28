import SwiftUI

struct SearchFoodView: View {
    @State private var query = ""
    @State private var searchResults: [FoodItem] = []
    @State private var isSearching = false
    @State private var errorMessage: String = ""
    @State private var showErrorAlert = false
    @State private var showInfoAlert = false
    
    var apiController = FoodAPIController()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(query: $query, isSearching: $isSearching, onSearchButtonTapped: searchFood)
                    .padding(.horizontal)
                
                List(searchResults) { foodItem in
                    SearchFoodListItem(foodItem: foodItem)
                }
            }
            .navigationTitle("Search Food")
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInfoAlert = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .alert(isPresented: $showInfoAlert) {
                Alert(
                    title: Text("Search Query Guide"),
                    message: Text("Enter the food or drink items you want to search for. You can also specify the quantity by prefixing it before the item. For example, '3 tomatoes' or '1lb beef brisket'. If no quantity is specified, the default is 100 grams.\n\nTo search for multiple items, separate them with commas. For example, 'bread, butter, milk'."),
                    dismissButton: .default(Text("Close"))
                )
            }
        }
    }
    
    private func searchFood() {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        apiController.searchFoodItems(withQuery: query) { [self] (foodItems, error) in
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } else if let foodItems = foodItems {
                if foodItems.isEmpty {
                    errorMessage = "No results found for the given query."
                    showErrorAlert = true
                } else {
                    searchResults = foodItems
                }
            }
            
            isSearching = false
        }
    }
}

import SwiftUI

struct SearchFoodView: View {
    @State private var query = ""
    @State private var searchResults: [FoodItem] = []
    @State private var isSearching = false
    @State private var errorMessage: String = ""
    @State private var showErrorAlert = false

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

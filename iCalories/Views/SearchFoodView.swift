import SwiftUI

struct SearchFoodView: View {
    @State private var query = ""
    @State private var searchResults: [FoodItem] = []
    @State private var isSearching = false

    var apiController = USDAFoodAPIController()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(query: $query, isSearching: $isSearching, onSearchButtonTapped: searchFood)
                    .padding(.horizontal)

                List(searchResults, id: \.fdcId) { foodItem in
                    SearchListItem(foodItem: foodItem)
                }
            }
            .navigationTitle("Search Food")
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
                print("Error: \(error)")
                return
            }

            if let foodItems = foodItems {
                DispatchQueue.main.async {
                    searchResults = foodItems
                    isSearching = false
                }
            }
        }
    }
}


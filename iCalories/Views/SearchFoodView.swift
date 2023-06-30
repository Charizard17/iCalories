import SwiftUI

struct SearchFoodView: View {
    @State private var query = ""
    @State private var searchResults: [FoodItem] = []
    @State private var isSearching = false
    @State private var errorMessage: String = ""
    @State private var showErrorAlert = false
    @State private var showInfoAlert = false
    
    let infoTitle = "Search Query Guide"
    let infoMessage = "Enter the food or drink items you want to search for. You can also specify the quantity by prefixing it before the item. For example, '3 tomatoes' or '1lb beef brisket'. If no quantity is specified, the default is 100 grams.\n\nTo search for multiple items, separate them with commas. For example, 'bread, butter, milk'."
    
    var apiController = FoodAPIController()
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.systemTeal
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(query: $query, isSearching: $isSearching, onSearchButtonTapped: searchFood)
                    .padding(.horizontal)
                
                ZStack {
                    List(searchResults) { foodItem in
                        SearchFoodItem(foodItem: foodItem)
                    }
                    
                    if isSearching {
                        ProgressView()
                            .scaleEffect(3)
                            .tint(.teal)
                    }
                }
            }
            .navigationTitle("Search Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInfoAlert = true
                    }) {
                        Label("Info", systemImage: "info.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.teal)
                    }
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showInfoAlert) {
                Alert(
                    title: Text(infoTitle),
                    message: Text(infoMessage),
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
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                    print("Error occurred: \(errorMessage)")
                } else if let foodItems = foodItems {
                    searchResults = foodItems
                    if foodItems.isEmpty {
                        errorMessage = "No results found for the given query."
                        showErrorAlert = true
                        print("No results found.")
                    }
                }
                
                isSearching = false
            }
        }
    }
    
}

struct SearchFoodView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFoodView()
    }
}

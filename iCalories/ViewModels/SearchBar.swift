//
//  SearchBar.swift
//  iCalories
//
//  Created by Esad Dursun on 27.06.23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var query: String
    @Binding var isSearching: Bool
    var onSearchButtonTapped: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search for food", text: $query, onCommit: onSearchButtonTapped)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .foregroundColor(.primary)
            
            Button(action: onSearchButtonTapped) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .disabled(isSearching)
        }
        .padding()
    }
}
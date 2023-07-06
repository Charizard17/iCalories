//
//  ContentView.swift
//  iCalories
//
//  Created by Esad Dursun on 30.06.23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            FoodListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .font(.system(size: iconSizeLarge, weight: .bold))
                }
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: iconSizeLarge, weight: .bold))
                }
            CalculatorView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                        .font(.system(size: iconSizeLarge, weight: .bold))
                }
        }
        .accentColor(.teal)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

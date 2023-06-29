//
//  SplashScreenView.swift
//  iCalories
//
//  Created by Esad Dursun on 29.06.23.
//

import SwiftUI

struct SplashScreenView: View {
    @StateObject private var dataController = DataController()
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
        else {
            VStack {
                VStack {
                    Image(uiImage: UIImage(named: "iCaloriesLogo") ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("iCalories")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.teal)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

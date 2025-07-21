//
//  ContentView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Reference Tools Tab
            NavigationView {
                ReferenceView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "square.grid.2x2")
                Text("Reference")
            }
            .tag(0)
            
            // Calculator Tools Tab
            NavigationView {
                CalculatorView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "wrench.and.screwdriver")
                Text("Tools")
            }
            .tag(1)
            
            // Favorites Tab
            NavigationView {
                FavoritesView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            .tag(2)
            
            // Settings Tab
            NavigationView {
                SettingsView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(3)
        }
        .preferredColorScheme(.dark)
        .neonTabBar()
    }
}

#Preview {
    ContentView()
}

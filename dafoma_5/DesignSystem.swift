//
//  DesignSystem.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

// MARK: - Color Scheme
extension Color {
    static let neonBackground = Color(hex: "#111216")!
    static let neonSecondaryBackground = Color(hex: "#1b1d23")!
    static let neonGreen = Color(hex: "#00ff94")!
    static let neonPink = Color(hex: "#ff007c")!
    static let neonBlue = Color(hex: "#2eaaff")!
}

// MARK: - Color Extension for Hex
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
struct NeonFont {
    static let largeTitle = Font.system(size: 32, weight: .bold, design: .rounded)
    static let title = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 18, weight: .medium, design: .rounded)
    static let body = Font.system(size: 16, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 12, weight: .regular, design: .rounded)
}

// MARK: - Glow Effect
struct GlowEffect: ViewModifier {
    let color: Color
    let intensity: Double
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: intensity * 2)
            .shadow(color: color.opacity(0.4), radius: intensity * 4)
            .shadow(color: color.opacity(0.2), radius: intensity * 8)
    }
}

extension View {
    func neonGlow(color: Color = .neonGreen, intensity: Double = 3) -> some View {
        modifier(GlowEffect(color: color, intensity: intensity))
    }
}

// MARK: - Neon Card Style
struct NeonCardStyle: ViewModifier {
    let borderColor: Color
    
    func body(content: Content) -> some View {
        content
            .background(Color.neonSecondaryBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 2)
                    .neonGlow(color: borderColor, intensity: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func neonCard(borderColor: Color = .neonGreen) -> some View {
        modifier(NeonCardStyle(borderColor: borderColor))
    }
}

// MARK: - Navigation Bar Appearance (iOS 15.6 Compatible)
struct NeonNavigationBarStyle: ViewModifier {
    init() {
        // Configure navigation bar appearance for iOS 15.6
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color.neonBackground)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func neonNavigationBar() -> some View {
        modifier(NeonNavigationBarStyle())
    }
}

// MARK: - Tab Bar Appearance (iOS 15.6 Compatible)
struct NeonTabBarStyle: ViewModifier {
    init() {
        // Configure tab bar appearance for iOS 15.6
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.neonBackground)
        
        // Normal state
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.white.opacity(0.6))
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.white.opacity(0.6))
        ]
        
        // Selected state
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.neonGreen)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.neonGreen)
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = UIColor(Color.neonGreen)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white.opacity(0.6))
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func neonTabBar() -> some View {
        modifier(NeonTabBarStyle())
    }
} 

//
//  Models.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

// MARK: - Reference Card Types
enum ReferenceCardType: String, CaseIterable {
    case ratios = "Visual Ratios"
    case spacing = "8pt Grid"
    case typography = "Typography Scale"
    case safeZones = "Safe Zones"
    case gridSystems = "Grid Systems"
    
    var icon: String {
        switch self {
        case .ratios: return "rectangle.ratio.3.to.4"
        case .spacing: return "grid"
        case .typography: return "textformat.size"
        case .safeZones: return "rectangle.inset.filled"
        case .gridSystems: return "grid.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .ratios: return .neonGreen
        case .spacing: return .neonPink
        case .typography: return .neonBlue
        case .safeZones: return .neonGreen
        case .gridSystems: return .neonPink
        }
    }
    
    var description: String {
        switch self {
        case .ratios: return "4:3, 16:9, 21:9, 1:1 aspect ratios"
        case .spacing: return "8-point spacing system reference"
        case .typography: return "Modular scale typography guide"
        case .safeZones: return "iOS safe area layout guides"
        case .gridSystems: return "6 & 12 column grid layouts"
        }
    }
}

// MARK: - Reference Card Model
struct ReferenceCard: Identifiable {
    let id = UUID()
    let type: ReferenceCardType
    let title: String
    let subtitle: String
    let color: Color
    
    init(type: ReferenceCardType) {
        self.type = type
        self.title = type.rawValue
        self.subtitle = type.description
        self.color = type.color
    }
}

// MARK: - Aspect Ratio Model
struct AspectRatio: Identifiable {
    let id = UUID()
    let name: String
    let ratio: CGFloat
    let width: CGFloat
    let height: CGFloat
    let description: String
    let color: Color
    
    static let common: [AspectRatio] = [
        AspectRatio(name: "4:3", ratio: 4/3, width: 4, height: 3, description: "Classic display ratio", color: .neonGreen),
        AspectRatio(name: "16:9", ratio: 16/9, width: 16, height: 9, description: "Widescreen standard", color: .neonBlue),
        AspectRatio(name: "21:9", ratio: 21/9, width: 21, height: 9, description: "Ultra-wide cinema", color: .neonPink),
        AspectRatio(name: "1:1", ratio: 1, width: 1, height: 1, description: "Perfect square", color: .neonGreen)
    ]
}

// MARK: - Typography Scale Model
struct TypographyScale: Identifiable {
    let id = UUID()
    let name: String
    let size: CGFloat
    let lineHeight: CGFloat
    let weight: Font.Weight
    let usage: String
    
    static let modularScale: [TypographyScale] = [
        TypographyScale(name: "Large Title", size: 34, lineHeight: 41, weight: .bold, usage: "Hero headlines"),
        TypographyScale(name: "Title 1", size: 28, lineHeight: 34, weight: .bold, usage: "Primary titles"),
        TypographyScale(name: "Title 2", size: 22, lineHeight: 28, weight: .bold, usage: "Secondary titles"),
        TypographyScale(name: "Title 3", size: 20, lineHeight: 25, weight: .semibold, usage: "Tertiary titles"),
        TypographyScale(name: "Headline", size: 17, lineHeight: 22, weight: .semibold, usage: "Emphasis text"),
        TypographyScale(name: "Body", size: 17, lineHeight: 22, weight: .regular, usage: "Primary content"),
        TypographyScale(name: "Callout", size: 16, lineHeight: 21, weight: .regular, usage: "Secondary content"),
        TypographyScale(name: "Subhead", size: 15, lineHeight: 20, weight: .regular, usage: "Subtitles"),
        TypographyScale(name: "Footnote", size: 13, lineHeight: 18, weight: .regular, usage: "Supplementary"),
        TypographyScale(name: "Caption 1", size: 12, lineHeight: 16, weight: .regular, usage: "Image captions"),
        TypographyScale(name: "Caption 2", size: 11, lineHeight: 13, weight: .regular, usage: "Fine print")
    ]
}

// MARK: - Grid System Model
struct GridSystem: Identifiable {
    let id = UUID()
    let name: String
    let columns: Int
    let gutter: CGFloat
    let margin: CGFloat
    let description: String
    
    static let common: [GridSystem] = [
        GridSystem(name: "6 Column", columns: 6, gutter: 16, margin: 20, description: "Mobile-first layout"),
        GridSystem(name: "12 Column", columns: 12, gutter: 24, margin: 32, description: "Desktop standard")
    ]
} 
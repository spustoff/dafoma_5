//
//  TypographyScaleView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct TypographyScaleView: View {
    @State private var selectedScale: TypographyScale?
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Typography hierarchy visual
                    typographyHierarchySection
                    
                    // Detailed scale cards
                    ForEach(TypographyScale.modularScale) { scale in
                        TypographyScaleCard(scale: scale, isSelected: selectedScale?.id == scale.id)
                            .onTapGesture {
                                selectedScale = selectedScale?.id == scale.id ? nil : scale
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
                    .navigationTitle("Typography Scale")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .neonNavigationBar()
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Export") {
                    exportCurrentView()
                }
                .foregroundColor(.neonBlue)
                .font(NeonFont.body)
            }
        }
    }
    
    private var typographyHierarchySection: some View {
        VStack(spacing: 20) {
            Text("Modular Scale Hierarchy")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonBlue, intensity: 2)
            
            VStack(spacing: 16) {
                ForEach(Array(TypographyScale.modularScale.prefix(6)), id: \.id) { scale in
                    TypographyHierarchyRow(
                        scale: scale,
                        isLast: scale.id == TypographyScale.modularScale.prefix(6).last?.id
                    )
                }
            }
            .padding(20)
            .neonCard(borderColor: .neonBlue)
        }
    }
    
    private func exportCurrentView() {
        Task { @MainActor in
            let exportView = TypographyScaleExportView()
            ExportHelper.exportViewAsPNG(exportView, fileName: "BlinkRatio_TypographyScale")
        }
    }
}

struct TypographyScaleCard: View {
    let scale: TypographyScale
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Main content
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(scale.name)
                        .font(.system(size: scale.size, weight: scale.weight, design: .rounded))
                        .foregroundColor(.neonBlue)
                        .neonGlow(color: .neonBlue, intensity: isSelected ? 3 : 1)
                    
                    Text(scale.usage)
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    TypeSpecView(label: "Size", value: "\(Int(scale.size))pt")
                    TypeSpecView(label: "Line Height", value: "\(Int(scale.lineHeight))pt")
                    TypeSpecView(label: "Weight", value: weightName(for: scale.weight))
                }
            }
            
            // Expanded details
            if isSelected {
                expandedDetails
            }
        }
        .padding(20)
        .neonCard(borderColor: isSelected ? .neonBlue : .neonBlue.opacity(0.5))
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
    
    private var expandedDetails: some View {
        VStack(spacing: 16) {
            Divider()
                .overlay(Color.neonBlue.opacity(0.3))
            
            // Sample text with actual size
            VStack(spacing: 12) {
                Text("Sample Text")
                    .font(.system(size: scale.size, weight: scale.weight, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.")
                    .font(.system(size: scale.size, weight: scale.weight, design: .rounded))
                    .lineSpacing(scale.lineHeight - scale.size)
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(Color.neonSecondaryBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Ratio information
            HStack(spacing: 24) {
                RatioInfoView(
                    label: "Scale Ratio",
                    value: String(format: "%.2f", scale.size / 17), // Base size 17pt
                    color: .neonBlue
                )
                
                RatioInfoView(
                    label: "Line Height Ratio",
                    value: String(format: "%.2f", scale.lineHeight / scale.size),
                    color: .neonBlue
                )
                
                RatioInfoView(
                    label: "Spacing",
                    value: "\(Int(scale.lineHeight - scale.size))pt",
                    color: .neonBlue
                )
            }
        }
    }
    
    private func weightName(for weight: Font.Weight) -> String {
        switch weight {
        case .ultraLight: return "Ultra Light"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Regular"
        }
    }
}

struct TypeSpecView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(label)
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.6))
            
            Text(value)
                .font(NeonFont.body)
                .foregroundColor(.neonBlue)
                .neonGlow(color: .neonBlue, intensity: 1)
        }
    }
}

struct RatioInfoView: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(NeonFont.body)
                .foregroundColor(color)
                .neonGlow(color: color, intensity: 1)
        }
    }
}

// MARK: - Export View
struct TypographyScaleExportView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                Text("BLINKRATIO")
                    .font(NeonFont.largeTitle)
                    .foregroundColor(.neonBlue)
                    .neonGlow(color: .neonBlue, intensity: 3)
                
                Text("Typography Scale Reference")
                    .font(NeonFont.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Typography samples
            VStack(spacing: 12) {
                ForEach(Array(TypographyScale.modularScale.prefix(8)), id: \.id) { scale in
                    TypographyExportRow(
                        scale: scale,
                        isLast: scale.id == TypographyScale.modularScale.prefix(8).last?.id
                    )
                }
            }
            .padding(16)
            .background(Color.neonSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonBlue, lineWidth: 2)
            )
            
            // Scale ratios
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("Base Size")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("17pt")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.neonBlue)
                }
                
                VStack(spacing: 4) {
                    Text("Scale Factor")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("1.2x")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.neonBlue)
                }
                
                VStack(spacing: 4) {
                    Text("Line Height")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("1.25x")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.neonBlue)
                }
            }
            .padding(12)
            .background(Color.neonSecondaryBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(24)
        .background(Color.neonBackground)
        .frame(width: 400, height: 600)
    }
}

struct TypographyHierarchyRow: View {
    let scale: TypographyScale
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(scale.name)
                    .font(.system(size: scale.size, weight: scale.weight, design: .rounded))
                    .foregroundColor(.neonBlue)
                    .neonGlow(color: .neonBlue, intensity: 1)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(scale.size))pt")
                        .font(NeonFont.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(Int(scale.lineHeight))pt")
                        .font(NeonFont.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 16)
            
            if !isLast {
                Divider()
                    .overlay(Color.neonBlue.opacity(0.3))
                    .padding(.top, 16)
            }
        }
    }
}

struct TypographyExportRow: View {
    let scale: TypographyScale
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(scale.name)
                    .font(.system(size: min(scale.size, 20), weight: scale.weight, design: .rounded))
                    .foregroundColor(.neonBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(Int(scale.size))pt")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(Int(scale.lineHeight))pt")
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            
            if !isLast {
                Divider()
                    .overlay(Color.neonBlue.opacity(0.2))
            }
        }
    }
}

#Preview {
    NavigationView {
        TypographyScaleView()
    }
} 
//
//  CalculatorView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct CalculatorView: View {
    @State private var selectedTool: CalculatorTool?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(CalculatorTool.allCases, id: \.self) { tool in
                        NavigationLink(destination: destinationView(for: tool)) {
                            CalculatorToolCard(tool: tool)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Design Tools")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
    }
    
    @ViewBuilder
    private func destinationView(for tool: CalculatorTool) -> some View {
        switch tool {
        case .ratioCalculator:
            RatioCalculatorView()
        case .unitConverter:
            UnitConverterView()
        case .spacingCalculator:
            SpacingCalculatorView()
        case .colorTools:
            ColorToolsView()
        }
    }
}

enum CalculatorTool: String, CaseIterable {
    case ratioCalculator = "Ratio Calculator"
    case unitConverter = "Unit Converter"
    case spacingCalculator = "Spacing Calculator"
    case colorTools = "Color Tools"
    
    var icon: String {
        switch self {
        case .ratioCalculator: return "divide.square"
        case .unitConverter: return "arrow.left.arrow.right.square"
        case .spacingCalculator: return "ruler"
        case .colorTools: return "paintpalette"
        }
    }
    
    var description: String {
        switch self {
        case .ratioCalculator: return "Calculate aspect ratios and proportions"
        case .unitConverter: return "Convert between px, pt, rem, and more"
        case .spacingCalculator: return "Generate spacing scales and rhythm"
        case .colorTools: return "Color palettes and contrast checker"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .ratioCalculator: return .neonGreen
        case .unitConverter: return .neonBlue
        case .spacingCalculator: return .neonPink
        case .colorTools: return .neonGreen
        }
    }
}

struct CalculatorToolCard: View {
    let tool: CalculatorTool
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: tool.icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(tool.accentColor)
                .neonGlow(color: tool.accentColor, intensity: 2)
            
            // Content
            VStack(spacing: 8) {
                Text(tool.rawValue)
                    .font(NeonFont.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(tool.description)
                    .font(NeonFont.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .neonCard(borderColor: tool.accentColor)
    }
}

#Preview {
    NavigationView {
        CalculatorView()
    }
} 
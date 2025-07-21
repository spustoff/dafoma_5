//
//  RatioCardsView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct RatioCardsView: View {
    @State private var selectedRatio: AspectRatio?
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(AspectRatio.common) { ratio in
                        RatioCardDetailView(ratio: ratio)
                            .onTapGesture {
                                selectedRatio = ratio
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
                    .navigationTitle("Visual Ratios")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .neonNavigationBar()
            .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Export") {
                    exportCurrentView()
                }
                .foregroundColor(.neonGreen)
                .font(NeonFont.body)
            }
        }
    }
    
    private func exportCurrentView() {
        Task { @MainActor in
            let exportView = RatioCardsExportView()
            ExportHelper.exportViewAsPNG(exportView, fileName: "BlinkRatio_VisualRatios")
        }
    }
}

struct RatioCardDetailView: View {
    let ratio: AspectRatio
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ratio.name)
                        .font(NeonFont.title)
                        .foregroundColor(.white)
                        .neonGlow(color: ratio.color, intensity: 2)
                    
                    Text(ratio.description)
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("\(Int(ratio.width)):\(Int(ratio.height))")
                    .font(NeonFont.headline)
                    .foregroundColor(ratio.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(ratio.color.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .neonGlow(color: ratio.color, intensity: 1)
            }
            
            // Visual Ratio Rectangle
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.neonSecondaryBackground)
                    .aspectRatio(ratio.ratio, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ratio.color, lineWidth: 3)
                            .neonGlow(color: ratio.color, intensity: 3)
                    )
                
                // Ratio Label Inside
                Text(ratio.name)
                    .font(NeonFont.largeTitle)
                    .foregroundColor(ratio.color)
                    .neonGlow(color: ratio.color, intensity: 2)
            }
            .frame(maxHeight: 200)
            
            // Precise Measurements
            HStack(spacing: 32) {
                MeasurementView(label: "Width", value: ratio.width, color: ratio.color)
                MeasurementView(label: "Height", value: ratio.height, color: ratio.color)
                MeasurementView(label: "Ratio", value: ratio.ratio, color: ratio.color, precision: 3)
            }
        }
        .padding(20)
        .neonCard(borderColor: ratio.color)
    }
}

struct MeasurementView: View {
    let label: String
    let value: CGFloat
    let color: Color
    let precision: Int
    
    init(label: String, value: CGFloat, color: Color, precision: Int = 0) {
        self.label = label
        self.value = value
        self.color = color
        self.precision = precision
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(formatValue())
                .font(NeonFont.body)
                .foregroundColor(color)
                .neonGlow(color: color, intensity: 1)
        }
    }
    
    private func formatValue() -> String {
        if precision > 0 {
            return String(format: "%.\(precision)f", value)
        } else {
            return "\(Int(value))"
        }
    }
}

// MARK: - Export View
struct RatioCardsExportView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("BLINKRATIO")
                    .font(NeonFont.largeTitle)
                    .foregroundColor(.neonGreen)
                    .neonGlow(color: .neonGreen, intensity: 3)
                
                Text("Visual Aspect Ratios Reference")
                    .font(NeonFont.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 20)
            
            // Compact Ratio Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(AspectRatio.common) { ratio in
                    CompactRatioView(ratio: ratio)
                }
            }
        }
        .padding(24)
        .background(Color.neonBackground)
        .frame(width: 400, height: 600)
    }
}

struct CompactRatioView: View {
    let ratio: AspectRatio
    
    var body: some View {
        VStack(spacing: 12) {
            Text(ratio.name)
                .font(NeonFont.headline)
                .foregroundColor(.white)
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.neonSecondaryBackground)
                    .aspectRatio(ratio.ratio, contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ratio.color, lineWidth: 2)
                    )
                
                Text("\(Int(ratio.width)):\(Int(ratio.height))")
                    .font(NeonFont.caption)
                    .foregroundColor(ratio.color)
            }
            .frame(height: 80)
            
            Text(ratio.description)
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .neonCard(borderColor: ratio.color)
    }
}

#Preview {
    NavigationView {
        RatioCardsView()
    }
} 
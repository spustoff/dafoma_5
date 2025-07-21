//
//  SpacingGridView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct SpacingGridView: View {
    @State private var showGrid = true
    @State private var gridOpacity: Double = 0.5
    
    private let spacingValues = [4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64, 72, 80, 96]
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Grid Controls
                    gridControlsSection
                    
                    // Visual Grid Demo
                    visualGridSection
                    
                    // Spacing Scale Reference
                    spacingScaleSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("8pt Grid")
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
        .neonNavigationBar()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Export") {
                    exportCurrentView()
                }
                .foregroundColor(.neonPink)
                .font(NeonFont.body)
            }
        }
    }
    
    private var gridControlsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Grid Overlay")
                    .font(NeonFont.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Toggle("", isOn: $showGrid)
                    .toggleStyle(NeonToggleStyle())
            }
            
            if showGrid {
                VStack(spacing: 8) {
                    Text("Opacity: \(Int(gridOpacity * 100))%")
                        .font(NeonFont.body)
                        .foregroundColor(.neonPink)
                    
                    Slider(value: $gridOpacity, in: 0.1...1.0)
                        .accentColor(.neonPink)
                }
            }
        }
        .padding(20)
        .neonCard(borderColor: .neonPink)
    }
    
    private var visualGridSection: some View {
        VStack(spacing: 16) {
            Text("8pt Grid System")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonPink, intensity: 2)
            
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.neonSecondaryBackground)
                    .frame(height: 320)
                
                // Grid Overlay
                if showGrid {
                    GridOverlay(spacing: 8, opacity: gridOpacity)
                }
                
                // Sample Content
                sampleContentLayout
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonPink, lineWidth: 2)
                    .neonGlow(color: .neonPink, intensity: 2)
            )
        }
    }
    
    private var sampleContentLayout: some View {
        VStack(spacing: 16) {
            // Header with 8pt spacing
            VStack(spacing: 8) {
                Text("Sample Layout")
                    .font(NeonFont.headline)
                    .foregroundColor(.neonPink)
                
                Text("All elements align to 8pt grid")
                    .font(NeonFont.body)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.top, 24)
            
            // Content blocks with proper spacing
            VStack(spacing: 16) {
                sampleBlock(height: 32, color: .neonGreen)
                sampleBlock(height: 24, color: .neonBlue)
                sampleBlock(height: 40, color: .neonPink)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
    
    private func sampleBlock(height: CGFloat, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.opacity(0.3))
            .frame(height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
    }
    
    private var spacingScaleSection: some View {
        VStack(spacing: 16) {
            Text("Spacing Scale")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonPink, intensity: 2)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(spacingValues, id: \.self) { value in
                    SpacingValueCard(value: value)
                }
            }
        }
    }
    
    private func exportCurrentView() {
        Task { @MainActor in
            let exportView = SpacingGridExportView()
            ExportHelper.exportViewAsPNG(exportView, fileName: "BlinkRatio_8ptGrid")
        }
    }
}

struct GridOverlay: View {
    let spacing: CGFloat
    let opacity: Double
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Vertical lines
                var x: CGFloat = 0
                while x <= width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: height))
                    x += spacing
                }
                
                // Horizontal lines
                var y: CGFloat = 0
                while y <= height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                    y += spacing
                }
            }
            .stroke(Color.neonPink.opacity(opacity), lineWidth: 0.5)
        }
    }
}

struct SpacingValueCard: View {
    let value: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(value)pt")
                .font(NeonFont.headline)
                .foregroundColor(.neonPink)
                .neonGlow(color: .neonPink, intensity: 1)
            
            // Visual representation
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.neonPink.opacity(0.3))
                .frame(width: CGFloat(value) * 2, height: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.neonPink, lineWidth: 1)
                )
            
            Text("Multiples of 8")
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(16)
        .frame(height: 100)
        .neonCard(borderColor: .neonPink)
    }
}

struct NeonToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            NeonToggleButton(isOn: configuration.isOn) {
                configuration.isOn.toggle()
            }
        }
    }
}

struct NeonToggleButton: View {
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            toggleBackground
                .overlay(toggleThumb)
                .overlay(toggleBorder)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var toggleBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isOn ? Color.neonPink : Color.neonSecondaryBackground)
            .frame(width: 50, height: 30)
    }
    
    private var toggleThumb: some View {
        Circle()
            .fill(.white)
            .frame(width: 24, height: 24)
            .offset(x: isOn ? 10 : -10)
            .animation(.easeInOut(duration: 0.2), value: isOn)
    }
    
    private var toggleBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.neonPink, lineWidth: 1)
    }
}

// MARK: - Export View
struct SpacingGridExportView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("BLINKRATIO")
                    .font(NeonFont.largeTitle)
                    .foregroundColor(.neonPink)
                    .neonGlow(color: .neonPink, intensity: 3)
                
                Text("8-Point Grid System Reference")
                    .font(NeonFont.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Grid with sample layout
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.neonSecondaryBackground)
                    .frame(height: 200)
                
                GridOverlay(spacing: 8, opacity: 0.3)
                
                VStack(spacing: 16) {
                    Text("All elements align to 8pt grid")
                        .font(NeonFont.body)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        ForEach([24, 32, 40], id: \.self) { height in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.neonPink.opacity(0.3))
                                .frame(width: 60, height: CGFloat(height))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.neonPink, lineWidth: 1)
                                )
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonPink, lineWidth: 2)
            )
            
            // Spacing values
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach([8, 16, 24, 32, 40, 48, 56, 64], id: \.self) { value in
                    VStack(spacing: 4) {
                        Text("\(value)pt")
                            .font(NeonFont.caption)
                            .foregroundColor(.neonPink)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.neonPink.opacity(0.5))
                            .frame(width: CGFloat(value) / 2, height: 4)
                    }
                }
            }
        }
        .padding(24)
        .background(Color.neonBackground)
        .frame(width: 400, height: 600)
    }
}

#Preview {
    NavigationView {
        SpacingGridView()
    }
} 

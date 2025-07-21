//
//  GridSystemsView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct GridSystemsView: View {
    @State private var selectedGrid: GridSystem = GridSystem.common[0]
    @State private var showGutters = true
    @State private var showMargins = true
    @State private var gridOpacity: Double = 0.6
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Grid controls
                    gridControlsSection
                    
                    // Grid visualization
                    gridVisualizationSection
                    
                    // Grid specifications
                    gridSpecificationsSection
                    
                    // Grid comparison
                    gridComparisonSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
                    .navigationTitle("Grid Systems")
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
            Text("Grid Configuration")
                .font(NeonFont.headline)
                .foregroundColor(.white)
            
            // Grid type selector
            HStack(spacing: 16) {
                ForEach(GridSystem.common, id: \.id) { grid in
                    GridSelectorButton(grid: grid, isSelected: selectedGrid.id == grid.id) {
                        selectedGrid = grid
                    }
                }
            }
            
            // Toggle controls
            VStack(spacing: 12) {
                HStack {
                    Toggle("Show Gutters", isOn: $showGutters)
                        .toggleStyle(NeonToggleStyle())
                    
                    Spacer()
                    
                    Toggle("Show Margins", isOn: $showMargins)
                        .toggleStyle(NeonToggleStyle())
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Grid Opacity")
                            .font(NeonFont.body)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(Int(gridOpacity * 100))%")
                            .font(NeonFont.body)
                            .foregroundColor(.neonPink)
                    }
                    
                    Slider(value: $gridOpacity, in: 0.1...1.0)
                        .accentColor(.neonPink)
                }
            }
        }
        .padding(20)
        .neonCard(borderColor: .neonPink)
    }
    
    private var gridVisualizationSection: some View {
        VStack(spacing: 16) {
            Text("\(selectedGrid.name) System")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonPink, intensity: 2)
            
            Text(selectedGrid.description)
                .font(NeonFont.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            // Grid visualization
            GridVisualization(
                grid: selectedGrid,
                showGutters: showGutters,
                showMargins: showMargins,
                opacity: gridOpacity
            )
        }
    }
    
    private var gridSpecificationsSection: some View {
        VStack(spacing: 16) {
            Text("Specifications")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonPink, intensity: 2)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                GridSpecCard(title: "Columns", value: "\(selectedGrid.columns)")
                GridSpecCard(title: "Gutter", value: "\(Int(selectedGrid.gutter))pt")
                GridSpecCard(title: "Margin", value: "\(Int(selectedGrid.margin))pt")
                GridSpecCard(title: "Column Width", value: calculateColumnWidth())
            }
        }
    }
    
    private var gridComparisonSection: some View {
        VStack(spacing: 16) {
            Text("Grid Comparison")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonPink, intensity: 2)
            
            HStack(spacing: 16) {
                ForEach(GridSystem.common, id: \.id) { grid in
                    CompactGridView(grid: grid, isSelected: selectedGrid.id == grid.id)
                        .onTapGesture {
                            selectedGrid = grid
                        }
                }
            }
        }
    }
    
    private func calculateColumnWidth() -> String {
        let screenWidth: CGFloat = 375 // iPhone standard width
        let totalMargin = selectedGrid.margin * 2
        let totalGutter = selectedGrid.gutter * CGFloat(selectedGrid.columns - 1)
        let availableWidth = screenWidth - totalMargin - totalGutter
        let columnWidth = availableWidth / CGFloat(selectedGrid.columns)
        return "\(Int(columnWidth))pt"
    }
    
    private func exportCurrentView() {
        Task { @MainActor in
            let exportView = GridSystemsExportView(selectedGrid: selectedGrid)
            ExportHelper.exportViewAsPNG(exportView, fileName: "BlinkRatio_GridSystems_\(selectedGrid.name.replacingOccurrences(of: " ", with: ""))")
        }
    }
}

struct GridVisualization: View {
    let grid: GridSystem
    let showGutters: Bool
    let showMargins: Bool
    let opacity: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let margin = grid.margin
            let gutter = grid.gutter
            let availableWidth = width - (margin * 2)
            let totalGutterWidth = gutter * CGFloat(grid.columns - 1)
            let columnWidth = (availableWidth - totalGutterWidth) / CGFloat(grid.columns)
            
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.neonSecondaryBackground)
                
                // Grid system
                HStack(spacing: 0) {
                    // Left margin
                    if showMargins {
                        Rectangle()
                            .fill(Color.neonBlue.opacity(opacity * 0.3))
                            .frame(width: margin)
                    } else {
                        Spacer().frame(width: margin)
                    }
                    
                    // Columns and gutters
                    HStack(spacing: gutter) {
                        ForEach(0..<grid.columns, id: \.self) { index in
                            Rectangle()
                                .fill(Color.neonPink.opacity(opacity))
                                .frame(width: columnWidth)
                                .overlay(
                                    Text("\(index + 1)")
                                        .font(NeonFont.caption)
                                        .foregroundColor(.white)
                                        .opacity(opacity > 0.5 ? 1 : 0)
                                )
                        }
                    }
                    
                    // Right margin
                    if showMargins {
                        Rectangle()
                            .fill(Color.neonBlue.opacity(opacity * 0.3))
                            .frame(width: margin)
                    } else {
                        Spacer().frame(width: margin)
                    }
                }
                
                // Gutter indicators
                if showGutters && grid.columns > 1 {
                    HStack(spacing: 0) {
                        Spacer().frame(width: margin + columnWidth)
                        
                        ForEach(0..<(grid.columns - 1), id: \.self) { _ in
                            Rectangle()
                                .fill(Color.neonGreen.opacity(opacity * 0.5))
                                .frame(width: gutter)
                            
                            Spacer().frame(width: columnWidth)
                        }
                        
                        Spacer().frame(width: margin)
                    }
                }
                
                // Measurements overlay
                measurementsOverlay(
                    width: width,
                    margin: margin,
                    gutter: gutter,
                    columnWidth: columnWidth
                )
            }
        }
        .frame(height: 200)
        .neonCard(borderColor: .neonPink)
    }
    
    private func measurementsOverlay(width: CGFloat, margin: CGFloat, gutter: CGFloat, columnWidth: CGFloat) -> some View {
        VStack {
            // Top measurements
            HStack {
                MeasurementLabel(value: "\(Int(margin))pt", color: .neonBlue)
                    .frame(width: margin)
                
                MeasurementLabel(value: "\(Int(columnWidth))pt", color: .neonPink)
                    .frame(width: columnWidth)
                
                if grid.columns > 1 {
                    MeasurementLabel(value: "\(Int(gutter))pt", color: .neonGreen)
                        .frame(width: gutter)
                }
                
                Spacer()
                
                MeasurementLabel(value: "\(Int(margin))pt", color: .neonBlue)
                    .frame(width: margin)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
}

struct CompactGridView: View {
    let grid: GridSystem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text(grid.name)
                .font(NeonFont.headline)
                .foregroundColor(isSelected ? .neonPink : .white)
                .neonGlow(color: .neonPink, intensity: isSelected ? 2 : 0)
            
            // Mini grid visualization
            GeometryReader { geometry in
                let width = geometry.size.width
                let margin: CGFloat = 4
                let gutter: CGFloat = 2
                let availableWidth = width - (margin * 2)
                let totalGutterWidth = gutter * CGFloat(grid.columns - 1)
                let columnWidth = (availableWidth - totalGutterWidth) / CGFloat(grid.columns)
                
                HStack(spacing: gutter) {
                    ForEach(0..<grid.columns, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.neonPink.opacity(isSelected ? 0.8 : 0.5))
                            .frame(width: columnWidth, height: 40)
                    }
                }
                .padding(.horizontal, margin)
            }
            .frame(height: 40)
            
            VStack(spacing: 4) {
                Text("\(grid.columns) columns")
                    .font(NeonFont.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(grid.description)
                    .font(NeonFont.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .neonCard(borderColor: isSelected ? .neonPink : .neonPink.opacity(0.5))
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

struct GridSpecCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(NeonFont.body)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(NeonFont.headline)
                .foregroundColor(.neonPink)
                .neonGlow(color: .neonPink, intensity: 1)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .neonCard(borderColor: .neonPink)
    }
}

// MARK: - Export View
struct GridSystemsExportView: View {
    let selectedGrid: GridSystem
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("BLINKRATIO")
                    .font(NeonFont.largeTitle)
                    .foregroundColor(.neonPink)
                    .neonGlow(color: .neonPink, intensity: 3)
                
                Text("Grid Systems Reference")
                    .font(NeonFont.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Selected grid visualization
            VStack(spacing: 12) {
                Text("\(selectedGrid.name) System")
                    .font(NeonFont.title)
                    .foregroundColor(.white)
                
                GridVisualization(
                    grid: selectedGrid,
                    showGutters: true,
                    showMargins: true,
                    opacity: 0.8
                )
                .frame(height: 120)
            }
            
            // Specifications
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SpecificationItem(label: "Columns", value: "\(selectedGrid.columns)")
                SpecificationItem(label: "Gutter", value: "\(Int(selectedGrid.gutter))pt")
                SpecificationItem(label: "Margin", value: "\(Int(selectedGrid.margin))pt")
                SpecificationItem(label: "Use Case", value: selectedGrid.description)
            }
            
            // Both grid systems comparison
            HStack(spacing: 16) {
                ForEach(GridSystem.common, id: \.id) { grid in
                    VStack(spacing: 8) {
                        Text(grid.name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                        
                        // Mini grid
                        HStack(spacing: 1) {
                            ForEach(0..<grid.columns, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.neonPink.opacity(0.6))
                                    .frame(width: 140 / CGFloat(grid.columns) - 1, height: 20)
                            }
                        }
                        .frame(width: 140)
                        
                        Text("\(grid.columns) cols, \(Int(grid.gutter))pt gutter")
                            .font(.system(size: 9, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(8)
                    .background(Color.neonSecondaryBackground.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(24)
        .background(Color.neonBackground)
        .frame(width: 400, height: 600)
    }
}

struct SpecificationItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.neonPink)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 50)
        .background(Color.neonSecondaryBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct GridSelectorButton: View {
    let grid: GridSystem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(grid.name)
                    .font(NeonFont.body)
                    .foregroundColor(textColor)
                
                Text("\(grid.columns) cols")
                    .font(NeonFont.caption)
                    .foregroundColor(subtitleColor)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(backgroundView)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        isSelected ? .neonBackground : .neonPink
    }
    
    private var subtitleColor: Color {
        isSelected ? .neonBackground.opacity(0.8) : .neonPink.opacity(0.8)
    }
    
    private var backgroundView: some View {
        let fillColor = isSelected ? Color.neonPink : Color.clear
        
        return RoundedRectangle(cornerRadius: 12)
            .fill(fillColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.neonPink, lineWidth: 2)
            )
    }
}

#Preview {
    NavigationView {
        GridSystemsView()
    }
} 

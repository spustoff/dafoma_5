//
//  CalculatorToolViews.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

// MARK: - Unit Converter View
struct UnitConverterView: View {
    @State private var inputValue: String = "16"
    @State private var fromUnit: DesignUnit = .px
    @State private var toUnit: DesignUnit = .pt
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Input Section
                    VStack(spacing: 16) {
                        Text("Unit Converter")
                            .font(NeonFont.title)
                            .foregroundColor(.neonBlue)
                            .neonGlow(color: .neonBlue, intensity: 2)
                        
                        HStack(spacing: 16) {
                            // Input Value
                            VStack(spacing: 8) {
                                Text("Value")
                                    .font(NeonFont.body)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextField("Enter value", text: $inputValue)
                                    .textFieldStyle(NeonTextFieldStyle())
                                    .frame(width: 100)
                            }
                            
                            // From Unit
                            VStack(spacing: 8) {
                                Text("From")
                                    .font(NeonFont.body)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Menu(fromUnit.rawValue) {
                                    ForEach(DesignUnit.allCases, id: \.self) { unit in
                                        Button(unit.rawValue) {
                                            fromUnit = unit
                                        }
                                    }
                                }
                                .foregroundColor(.neonBlue)
                                .padding(12)
                                .background(Color.neonSecondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.neonBlue, lineWidth: 1)
                                )
                            }
                            
                            Image(systemName: "arrow.right")
                                .font(.title2)
                                .foregroundColor(.neonGreen)
                            
                            // To Unit
                            VStack(spacing: 8) {
                                Text("To")
                                    .font(NeonFont.body)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Menu(toUnit.rawValue) {
                                    ForEach(DesignUnit.allCases, id: \.self) { unit in
                                        Button(unit.rawValue) {
                                            toUnit = unit
                                        }
                                    }
                                }
                                .foregroundColor(.neonBlue)
                                .padding(12)
                                .background(Color.neonSecondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.neonBlue, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .neonCard(borderColor: .neonBlue)
                    
                    // Result Section
                    if let result = convertUnits() {
                        VStack(spacing: 12) {
                            Text("Result")
                                .font(NeonFont.headline)
                                .foregroundColor(.neonGreen)
                                .neonGlow(color: .neonGreen, intensity: 2)
                            
                            Text("\(String(format: "%.2f", result)) \(toUnit.rawValue)")
                                .font(NeonFont.largeTitle)
                                .foregroundColor(.white)
                                .neonGlow(color: .neonGreen, intensity: 1)
                        }
                        .neonCard(borderColor: .neonGreen)
                    }
                    
                    // Common Conversions
                    commonConversionsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Unit Converter")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
    }
    
    private var commonConversionsSection: some View {
        VStack(spacing: 16) {
            Text("Common Conversions")
                .font(NeonFont.headline)
                .foregroundColor(.neonPink)
                .neonGlow(color: .neonPink, intensity: 2)
            
            VStack(spacing: 8) {
                ConversionRow(from: "16px", to: "12pt", description: "Standard base size")
                ConversionRow(from: "1rem", to: "16px", description: "Default rem value")
                ConversionRow(from: "1em", to: "16px", description: "Relative to parent")
                ConversionRow(from: "1in", to: "96px", description: "CSS inch")
            }
        }
        .neonCard(borderColor: .neonPink)
    }
    
    private func convertUnits() -> Double? {
        guard let value = Double(inputValue), value > 0 else { return nil }
        
        // Convert to base unit (px) first, then to target unit
        let baseValue = fromUnit.toPixels(value)
        return toUnit.fromPixels(baseValue)
    }
}

struct ConversionRow: View {
    let from: String
    let to: String
    let description: String
    
    var body: some View {
        HStack {
            Text(from)
                .font(NeonFont.body)
                .foregroundColor(.neonPink)
            
            Image(systemName: "arrow.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
            
            Text(to)
                .font(NeonFont.body)
                .foregroundColor(.neonBlue)
            
            Spacer()
            
            Text(description)
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.neonSecondaryBackground.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

enum DesignUnit: String, CaseIterable {
    case px = "px"
    case pt = "pt"
    case em = "em"
    case rem = "rem"
    case inch = "in"
    case cm = "cm"
    case mm = "mm"
    
    func toPixels(_ value: Double) -> Double {
        switch self {
        case .px: return value
        case .pt: return value * 1.333 // 1pt = 1.333px at 96dpi
        case .em: return value * 16 // Assuming 16px base
        case .rem: return value * 16 // Assuming 16px root
        case .inch: return value * 96 // 1in = 96px in CSS
        case .cm: return value * 37.795 // 1cm = 37.795px
        case .mm: return value * 3.7795 // 1mm = 3.7795px
        }
    }
    
    func fromPixels(_ pixels: Double) -> Double {
        switch self {
        case .px: return pixels
        case .pt: return pixels / 1.333
        case .em: return pixels / 16
        case .rem: return pixels / 16
        case .inch: return pixels / 96
        case .cm: return pixels / 37.795
        case .mm: return pixels / 3.7795
        }
    }
}

// MARK: - Spacing Calculator View
struct SpacingCalculatorView: View {
    @State private var baseSize: String = "8"
    @State private var scaleRatio: String = "1.5"
    @State private var steps: Int = 8
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Input Section
                    VStack(spacing: 16) {
                        Text("Spacing Scale Generator")
                            .font(NeonFont.title)
                            .foregroundColor(.neonPink)
                            .neonGlow(color: .neonPink, intensity: 2)
                        
                        HStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("Base Size")
                                    .font(NeonFont.body)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextField("8", text: $baseSize)
                                    .textFieldStyle(NeonTextFieldStyle())
                                    .frame(width: 80)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Scale Ratio")
                                    .font(NeonFont.body)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextField("1.5", text: $scaleRatio)
                                    .textFieldStyle(NeonTextFieldStyle())
                                    .frame(width: 80)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Steps")
                                    .font(NeonFont.body)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Stepper("\(steps)", value: $steps, in: 4...12)
                                    .foregroundColor(.neonPink)
                            }
                        }
                    }
                    .neonCard(borderColor: .neonPink)
                    
                    // Generated Scale
                    if let scale = generateSpacingScale() {
                        VStack(spacing: 16) {
                            Text("Generated Scale")
                                .font(NeonFont.headline)
                                .foregroundColor(.neonGreen)
                                .neonGlow(color: .neonGreen, intensity: 2)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(Array(scale.enumerated()), id: \.offset) { index, value in
                                    VStack(spacing: 8) {
                                        Text("Step \(index)")
                                            .font(NeonFont.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        Text("\(Int(value))px")
                                            .font(NeonFont.body)
                                            .foregroundColor(.neonGreen)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.neonPink.opacity(0.5))
                                            .frame(width: min(value * 2, 100), height: 8)
                                    }
                                    .padding(12)
                                    .background(Color.neonSecondaryBackground.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .neonCard(borderColor: .neonGreen)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Spacing Calculator")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
    }
    
    private func generateSpacingScale() -> [Double]? {
        guard let base = Double(baseSize), let ratio = Double(scaleRatio),
              base > 0, ratio > 0 else { return nil }
        
        var scale: [Double] = []
        for i in 0..<steps {
            let value = base * pow(ratio, Double(i))
            scale.append(value)
        }
        return scale
    }
}

// MARK: - Color Tools View
struct ColorToolsView: View {
    @State private var selectedColor: Color = .neonGreen
    @State private var hexInput: String = "00FF94"
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Color Picker Section
                    VStack(spacing: 16) {
                        Text("Color Tools")
                            .font(NeonFont.title)
                            .foregroundColor(.neonGreen)
                            .neonGlow(color: .neonGreen, intensity: 2)
                        
                        VStack(spacing: 12) {
                            ColorPicker("Select Color", selection: $selectedColor)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text("Hex:")
                                    .foregroundColor(.white.opacity(0.8))
                                
                                TextField("00FF94", text: $hexInput)
                                    .textFieldStyle(NeonTextFieldStyle())
                                    .frame(maxWidth: 120)
                                
                                Button("Apply") {
                                    if let color = Color(hex: hexInput) {
                                        selectedColor = color
                                    }
                                }
                                .foregroundColor(.neonGreen)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.neonSecondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                    .neonCard(borderColor: .neonGreen)
                    
                    // Color Preview
                    VStack(spacing: 16) {
                        Text("Color Preview")
                            .font(NeonFont.headline)
                            .foregroundColor(.neonBlue)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedColor)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .neonCard(borderColor: .neonBlue)
                    
                    // Neon Color Palette
                    VStack(spacing: 16) {
                        Text("Neon Palette")
                            .font(NeonFont.headline)
                            .foregroundColor(.neonPink)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            ColorSwatch(color: .neonGreen, name: "Neon Green", hex: "00FF94")
                            ColorSwatch(color: .neonPink, name: "Neon Pink", hex: "FF007C")
                            ColorSwatch(color: .neonBlue, name: "Neon Blue", hex: "2EAAFF")
                            ColorSwatch(color: .neonBackground, name: "Background", hex: "111216")
                            ColorSwatch(color: .neonSecondaryBackground, name: "Secondary", hex: "1B1D23")
                            ColorSwatch(color: .white, name: "White", hex: "FFFFFF")
                        }
                    }
                    .neonCard(borderColor: .neonPink)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Color Tools")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
    }
}

struct ColorSwatch: View {
    let color: Color
    let name: String
    let hex: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            VStack(spacing: 2) {
                Text(name)
                    .font(NeonFont.caption)
                    .foregroundColor(.white)
                
                Text("#\(hex)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(8)
        .background(Color.neonSecondaryBackground.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

 

//
//  RatioCalculatorView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct RatioCalculatorView: View {
    @State private var width1: String = "16"
    @State private var height1: String = "9"
    @State private var width2: String = ""
    @State private var height2: String = ""
    @State private var calculationMode: CalculationMode = .findMissing
    
    enum CalculationMode: String, CaseIterable {
        case findMissing = "Find Missing Value"
        case compareRatios = "Compare Ratios"
        case scaleRatio = "Scale Ratio"
    }
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Mode Selector
                    modeSelector
                    
                    // Calculator Content
                    calculatorContent
                    
                    // Results
                    resultsSection
                    
                    // Common Ratios Reference
                    commonRatiosReference
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Ratio Calculator")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
    }
    
    private var modeSelector: some View {
        VStack(spacing: 12) {
            Text("Calculation Mode")
                .font(NeonFont.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                ForEach(CalculationMode.allCases, id: \.self) { mode in
                    Button(mode.rawValue) {
                        calculationMode = mode
                        clearFields()
                    }
                    .font(NeonFont.caption)
                    .foregroundColor(calculationMode == mode ? .neonBackground : .neonGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(calculationMode == mode ? Color.neonGreen : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.neonGreen, lineWidth: 1)
                            )
                    )
                }
            }
        }
        .neonCard(borderColor: .neonGreen)
    }
    
    private var calculatorContent: some View {
        VStack(spacing: 20) {
            switch calculationMode {
            case .findMissing:
                findMissingValueContent
            case .compareRatios:
                compareRatiosContent
            case .scaleRatio:
                scaleRatioContent
            }
        }
        .neonCard(borderColor: .neonBlue)
    }
    
    private var findMissingValueContent: some View {
        VStack(spacing: 20) {
            Text("Find Missing Dimension")
                .font(NeonFont.title)
                .foregroundColor(.neonBlue)
                .neonGlow(color: .neonBlue, intensity: 2)
            
            HStack(spacing: 16) {
                // First Ratio
                VStack(spacing: 8) {
                    Text("Known Ratio")
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        TextField("Width", text: $width1)
                            .textFieldStyle(NeonTextFieldStyle())
                        
                        Text(":")
                            .font(NeonFont.title)
                            .foregroundColor(.neonBlue)
                        
                        TextField("Height", text: $height1)
                            .textFieldStyle(NeonTextFieldStyle())
                    }
                }
                
                Image(systemName: "arrow.right")
                    .font(.title2)
                    .foregroundColor(.neonGreen)
                
                // Second Ratio
                VStack(spacing: 8) {
                    Text("Find Missing")
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        TextField("Width", text: $width2)
                            .textFieldStyle(NeonTextFieldStyle())
                        
                        Text(":")
                            .font(NeonFont.title)
                            .foregroundColor(.neonBlue)
                        
                        TextField("Height", text: $height2)
                            .textFieldStyle(NeonTextFieldStyle())
                    }
                }
            }
            
            Text("Enter 3 values to calculate the 4th")
                .font(NeonFont.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var compareRatiosContent: some View {
        VStack(spacing: 20) {
            Text("Compare Two Ratios")
                .font(NeonFont.title)
                .foregroundColor(.neonBlue)
                .neonGlow(color: .neonBlue, intensity: 2)
            
            HStack(spacing: 20) {
                // First Ratio
                VStack(spacing: 8) {
                    Text("Ratio A")
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        TextField("Width", text: $width1)
                            .textFieldStyle(NeonTextFieldStyle())
                        
                        Text(":")
                            .font(NeonFont.title)
                            .foregroundColor(.neonBlue)
                        
                        TextField("Height", text: $height1)
                            .textFieldStyle(NeonTextFieldStyle())
                    }
                }
                
                Text("vs")
                    .font(NeonFont.title)
                    .foregroundColor(.neonPink)
                
                // Second Ratio
                VStack(spacing: 8) {
                    Text("Ratio B")
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 8) {
                        TextField("Width", text: $width2)
                            .textFieldStyle(NeonTextFieldStyle())
                        
                        Text(":")
                            .font(NeonFont.title)
                            .foregroundColor(.neonBlue)
                        
                        TextField("Height", text: $height2)
                            .textFieldStyle(NeonTextFieldStyle())
                    }
                }
            }
        }
    }
    
    private var scaleRatioContent: some View {
        VStack(spacing: 20) {
            Text("Scale Ratio")
                .font(NeonFont.title)
                .foregroundColor(.neonBlue)
                .neonGlow(color: .neonBlue, intensity: 2)
            
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    TextField("Width", text: $width1)
                        .textFieldStyle(NeonTextFieldStyle())
                    
                    Text(":")
                        .font(NeonFont.title)
                        .foregroundColor(.neonBlue)
                    
                    TextField("Height", text: $height1)
                        .textFieldStyle(NeonTextFieldStyle())
                }
                
                Text("Scale by factor:")
                    .font(NeonFont.body)
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("Scale Factor", text: $width2)
                    .textFieldStyle(NeonTextFieldStyle())
                    .frame(maxWidth: 120)
            }
        }
    }
    
    private var resultsSection: some View {
        VStack(spacing: 16) {
            if let result = calculateResult() {
                VStack(spacing: 12) {
                    Text("Result")
                        .font(NeonFont.headline)
                        .foregroundColor(.neonGreen)
                        .neonGlow(color: .neonGreen, intensity: 2)
                    
                    Text(result)
                        .font(NeonFont.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.neonSecondaryBackground.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .neonCard(borderColor: .neonGreen)
            }
        }
    }
    
    private var commonRatiosReference: some View {
        VStack(spacing: 16) {
            Text("Common Ratios")
                .font(NeonFont.headline)
                .foregroundColor(.neonPink)
                .neonGlow(color: .neonPink, intensity: 2)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(CommonRatio.allCases, id: \.self) { ratio in
                    Button(action: {
                        useCommonRatio(ratio)
                    }) {
                        VStack(spacing: 4) {
                            Text(ratio.rawValue)
                                .font(NeonFont.body)
                                .foregroundColor(.neonPink)
                            
                            Text(ratio.description)
                                .font(NeonFont.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.neonSecondaryBackground.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.neonPink, lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .neonCard(borderColor: .neonPink)
    }
    
    private func calculateResult() -> String? {
        switch calculationMode {
        case .findMissing:
            return calculateMissingValue()
        case .compareRatios:
            return compareRatios()
        case .scaleRatio:
            return scaleRatio()
        }
    }
    
    private func calculateMissingValue() -> String? {
        let w1 = Double(width1) ?? 0
        let h1 = Double(height1) ?? 0
        let w2 = Double(width2) ?? 0
        let h2 = Double(height2) ?? 0
        
        let values = [w1, h1, w2, h2]
        let nonZeroCount = values.filter { $0 > 0 }.count
        
        guard nonZeroCount == 3 else { return nil }
        
        if w1 > 0 && h1 > 0 && w2 > 0 && h2 == 0 {
            let result = (w2 * h1) / w1
            return "Missing height: \(String(format: "%.1f", result))"
        } else if w1 > 0 && h1 > 0 && w2 == 0 && h2 > 0 {
            let result = (h2 * w1) / h1
            return "Missing width: \(String(format: "%.1f", result))"
        }
        
        return nil
    }
    
    private func compareRatios() -> String? {
        guard let w1 = Double(width1), let h1 = Double(height1),
              let w2 = Double(width2), let h2 = Double(height2),
              w1 > 0, h1 > 0, w2 > 0, h2 > 0 else { return nil }
        
        let ratio1 = w1 / h1
        let ratio2 = w2 / h2
        
        let difference = abs(ratio1 - ratio2)
        let percentDiff = (difference / ratio1) * 100
        
        if difference < 0.01 {
            return "Ratios are identical!\n\(String(format: "%.3f", ratio1)) : 1"
        } else {
            return "Ratio A: \(String(format: "%.3f", ratio1)) : 1\nRatio B: \(String(format: "%.3f", ratio2)) : 1\nDifference: \(String(format: "%.1f", percentDiff))%"
        }
    }
    
    private func scaleRatio() -> String? {
        guard let w1 = Double(width1), let h1 = Double(height1),
              let scale = Double(width2),
              w1 > 0, h1 > 0, scale > 0 else { return nil }
        
        let newWidth = w1 * scale
        let newHeight = h1 * scale
        
        return "Scaled dimensions:\n\(String(format: "%.1f", newWidth)) : \(String(format: "%.1f", newHeight))"
    }
    
    private func useCommonRatio(_ ratio: CommonRatio) {
        let components = ratio.rawValue.split(separator: ":").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        if components.count == 2 {
            width1 = String(format: "%.0f", components[0])
            height1 = String(format: "%.0f", components[1])
        }
    }
    
    private func clearFields() {
        width2 = ""
        height2 = ""
    }
}

enum CommonRatio: String, CaseIterable {
    case golden = "1.618 : 1"
    case cinema = "21 : 9"
    case widescreen = "16 : 9"
    case traditional = "4 : 3"
    case square = "1 : 1"
    case portrait = "3 : 4"
    case instagram = "4 : 5"
    case story = "9 : 16"
    
    var description: String {
        switch self {
        case .golden: return "Golden Ratio"
        case .cinema: return "Cinema"
        case .widescreen: return "Widescreen"
        case .traditional: return "Traditional TV"
        case .square: return "Square"
        case .portrait: return "Portrait"
        case .instagram: return "Instagram"
        case .story: return "Story"
        }
    }
}

struct NeonTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(NeonFont.body)
            .foregroundColor(.white)
            .padding(12)
            .background(Color.neonSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.neonBlue, lineWidth: 1)
            )
            .keyboardType(.decimalPad)
    }
}

#Preview {
    NavigationView {
        RatioCalculatorView()
    }
} 
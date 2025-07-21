//
//  SafeZonesView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct SafeZonesView: View {
    @State private var selectedDevice: DeviceType = .iPhone14Pro
    @State private var showMeasurements = true
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Device selector
                    deviceSelectorSection
                    
                    // Safe zone visualization
                    safeZoneVisualizationSection
                    
                    // Safe zone specifications
                    safeZoneSpecsSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
                    .navigationTitle("Safe Zones")
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
    
    private var deviceSelectorSection: some View {
        VStack(spacing: 16) {
            Text("Device Type")
                .font(NeonFont.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(DeviceType.allCases, id: \.self) { device in
                    DeviceSelectorButton(
                        device: device,
                        isSelected: selectedDevice == device
                    ) {
                        selectedDevice = device
                    }
                }
            }
            
            Toggle("Show Measurements", isOn: $showMeasurements)
                .toggleStyle(NeonToggleStyle())
                .foregroundColor(.white)
        }
        .padding(20)
        .neonCard(borderColor: .neonGreen)
    }
    
    private var safeZoneVisualizationSection: some View {
        VStack(spacing: 16) {
            Text(selectedDevice.displayName + " Safe Areas")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonGreen, intensity: 2)
            
            DeviceFrame(device: selectedDevice, showMeasurements: showMeasurements)
        }
    }
    
    private var safeZoneSpecsSection: some View {
        VStack(spacing: 16) {
            Text("Specifications")
                .font(NeonFont.title)
                .foregroundColor(.white)
                .neonGlow(color: .neonGreen, intensity: 2)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                SafeZoneSpecCard(title: "Top Safe Area", value: "\(selectedDevice.topSafeArea)pt")
                SafeZoneSpecCard(title: "Bottom Safe Area", value: "\(selectedDevice.bottomSafeArea)pt")
                SafeZoneSpecCard(title: "Leading Safe Area", value: "\(selectedDevice.leadingSafeArea)pt")
                SafeZoneSpecCard(title: "Trailing Safe Area", value: "\(selectedDevice.trailingSafeArea)pt")
            }
            
            // Additional device info
            VStack(spacing: 12) {
                HStack {
                    Text("Screen Size:")
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\(Int(selectedDevice.screenSize.width)) × \(Int(selectedDevice.screenSize.height))pt")
                        .font(NeonFont.body)
                        .foregroundColor(.neonGreen)
                        .neonGlow(color: .neonGreen, intensity: 1)
                }
                
                HStack {
                    Text("Content Area:")
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\(Int(selectedDevice.contentArea.width)) × \(Int(selectedDevice.contentArea.height))pt")
                        .font(NeonFont.body)
                        .foregroundColor(.neonGreen)
                        .neonGlow(color: .neonGreen, intensity: 1)
                }
            }
            .padding(16)
            .neonCard(borderColor: .neonGreen)
        }
    }
    
    private func exportCurrentView() {
        Task { @MainActor in
            let exportView = SafeZonesExportView(device: selectedDevice)
            ExportHelper.exportViewAsPNG(exportView, fileName: "BlinkRatio_SafeZones_\(selectedDevice.rawValue)")
        }
    }
}

enum DeviceType: String, CaseIterable {
    case iPhone14Pro = "iPhone14Pro"
    case iPhone14 = "iPhone14" 
    case iPhoneSE = "iPhoneSE"
    case iPadPro = "iPadPro"
    
    var displayName: String {
        switch self {
        case .iPhone14Pro: return "iPhone 14 Pro"
        case .iPhone14: return "iPhone 14"
        case .iPhoneSE: return "iPhone SE"
        case .iPadPro: return "iPad Pro"
        }
    }
    
    var screenSize: CGSize {
        switch self {
        case .iPhone14Pro: return CGSize(width: 393, height: 852)
        case .iPhone14: return CGSize(width: 390, height: 844)
        case .iPhoneSE: return CGSize(width: 375, height: 667)
        case .iPadPro: return CGSize(width: 1024, height: 1366)
        }
    }
    
    var topSafeArea: CGFloat {
        switch self {
        case .iPhone14Pro: return 59
        case .iPhone14: return 47
        case .iPhoneSE: return 20
        case .iPadPro: return 24
        }
    }
    
    var bottomSafeArea: CGFloat {
        switch self {
        case .iPhone14Pro: return 34
        case .iPhone14: return 34
        case .iPhoneSE: return 0
        case .iPadPro: return 20
        }
    }
    
    var leadingSafeArea: CGFloat {
        switch self {
        case .iPhone14Pro, .iPhone14, .iPhoneSE: return 0
        case .iPadPro: return 0
        }
    }
    
    var trailingSafeArea: CGFloat {
        switch self {
        case .iPhone14Pro, .iPhone14, .iPhoneSE: return 0
        case .iPadPro: return 0
        }
    }
    
    var contentArea: CGSize {
        let width = screenSize.width - leadingSafeArea - trailingSafeArea
        let height = screenSize.height - topSafeArea - bottomSafeArea
        return CGSize(width: width, height: height)
    }
    
    var hasNotch: Bool {
        switch self {
        case .iPhone14Pro, .iPhone14: return true
        case .iPhoneSE, .iPadPro: return false
        }
    }
    
    var hasHomeIndicator: Bool {
        switch self {
        case .iPhone14Pro, .iPhone14: return true
        case .iPhoneSE, .iPadPro: return false
        }
    }
}

struct DeviceFrame: View {
    let device: DeviceType
    let showMeasurements: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let scale = min(geometry.size.width / device.screenSize.width, 300 / device.screenSize.height)
            let scaledWidth = device.screenSize.width * scale
            let scaledHeight = device.screenSize.height * scale
            
            VStack(spacing: 0) {
                ZStack {
                    // Device outline
                    RoundedRectangle(cornerRadius: device == .iPadPro ? 12 : 25)
                        .stroke(.white, lineWidth: 3)
                        .frame(width: scaledWidth, height: scaledHeight)
                    
                    // Screen content area
                    RoundedRectangle(cornerRadius: device == .iPadPro ? 8 : 20)
                        .fill(Color.neonSecondaryBackground)
                        .frame(width: scaledWidth - 6, height: scaledHeight - 6)
                    
                    // Safe area visualization
                    safeAreaOverlay(scale: scale)
                    
                    // Device-specific elements
                    deviceSpecificElements(scale: scale)
                    
                    // Measurements
                    if showMeasurements {
                        measurementOverlay(scale: scale)
                    }
                }
            }
        }
        .frame(height: 320)
        .neonCard(borderColor: .neonGreen)
    }
    
    private func safeAreaOverlay(scale: CGFloat) -> some View {
        let scaledWidth = device.screenSize.width * scale - 6
        let scaledHeight = device.screenSize.height * scale - 6
        let contentWidth = device.contentArea.width * scale
        let contentHeight = device.contentArea.height * scale
        
        return ZStack {
            // Safe area (content area)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.neonGreen.opacity(0.1))
                .frame(width: contentWidth, height: contentHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.neonGreen, lineWidth: 2)
                        .neonGlow(color: .neonGreen, intensity: 2)
                )
            
            // Safe area label
            Text("Safe Area")
                .font(NeonFont.caption)
                .foregroundColor(.neonGreen)
                .neonGlow(color: .neonGreen, intensity: 1)
        }
    }
    
    private func deviceSpecificElements(scale: CGFloat) -> some View {
        let scaledWidth = device.screenSize.width * scale - 6
        let scaledHeight = device.screenSize.height * scale - 6
        
        return ZStack {
            if device.hasNotch {
                // Dynamic island / notch
                RoundedRectangle(cornerRadius: device == .iPhone14Pro ? 20 : 15)
                    .fill(.black)
                    .frame(
                        width: device == .iPhone14Pro ? 120 * scale : 150 * scale,
                        height: device == .iPhone14Pro ? 30 * scale : 25 * scale
                    )
                    .offset(y: -scaledHeight/2 + (device == .iPhone14Pro ? 20 * scale : 15 * scale))
            }
            
            if device.hasHomeIndicator {
                // Home indicator
                RoundedRectangle(cornerRadius: 2)
                    .fill(.white.opacity(0.8))
                    .frame(width: 134 * scale, height: 5 * scale)
                    .offset(y: scaledHeight/2 - 15 * scale)
            }
        }
    }
    
    private func measurementOverlay(scale: CGFloat) -> some View {
        let scaledWidth = device.screenSize.width * scale - 6
        let scaledHeight = device.screenSize.height * scale - 6
        
        return ZStack {
            // Top safe area measurement
            VStack {
                HStack {
                    Spacer()
                    MeasurementLabel(value: "\(Int(device.topSafeArea))pt", color: .neonGreen)
                    Spacer()
                }
                .offset(y: -scaledHeight/2 + (device.topSafeArea * scale / 2))
                
                Spacer()
                
                // Bottom safe area measurement
                if device.bottomSafeArea > 0 {
                    HStack {
                        Spacer()
                        MeasurementLabel(value: "\(Int(device.bottomSafeArea))pt", color: .neonGreen)
                        Spacer()
                    }
                    .offset(y: scaledHeight/2 - (device.bottomSafeArea * scale / 2))
                }
            }
        }
    }
}

struct MeasurementLabel: View {
    let value: String
    let color: Color
    
    var body: some View {
        Text(value)
            .font(NeonFont.caption)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color, lineWidth: 1)
            )
            .neonGlow(color: color, intensity: 1)
    }
}

struct SafeZoneSpecCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(NeonFont.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(NeonFont.headline)
                .foregroundColor(.neonGreen)
                .neonGlow(color: .neonGreen, intensity: 1)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .neonCard(borderColor: .neonGreen)
    }
}

// MARK: - Export View
struct SafeZonesExportView: View {
    let device: DeviceType
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("BLINKRATIO")
                    .font(NeonFont.largeTitle)
                    .foregroundColor(.neonGreen)
                    .neonGlow(color: .neonGreen, intensity: 3)
                
                Text("Safe Zones Reference - \(device.displayName)")
                    .font(NeonFont.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Device visualization
            DeviceFrame(device: device, showMeasurements: true)
                .frame(height: 250)
            
            // Specifications grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SpecItem(label: "Screen Size", value: "\(Int(device.screenSize.width)) × \(Int(device.screenSize.height))pt")
                SpecItem(label: "Content Area", value: "\(Int(device.contentArea.width)) × \(Int(device.contentArea.height))pt")
                SpecItem(label: "Top Safe Area", value: "\(Int(device.topSafeArea))pt")
                SpecItem(label: "Bottom Safe Area", value: "\(Int(device.bottomSafeArea))pt")
            }
        }
        .padding(24)
        .background(Color.neonBackground)
        .frame(width: 400, height: 600)
    }
}

struct SpecItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.neonGreen)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(Color.neonSecondaryBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct DeviceSelectorButton: View {
    let device: DeviceType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(device.displayName)
                .font(NeonFont.body)
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(backgroundView)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        isSelected ? .neonBackground : .neonGreen
    }
    
    private var backgroundView: some View {
        let fillColor = isSelected ? Color.neonGreen : Color.clear
        
        return RoundedRectangle(cornerRadius: 20)
            .fill(fillColor)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.neonGreen, lineWidth: 1)
            )
    }
}

#Preview {
    NavigationView {
        SafeZonesView()
    }
} 
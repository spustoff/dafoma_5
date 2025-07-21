//
//  SettingsView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("exportQuality") private var exportQuality = ExportQuality.high
    @AppStorage("showMeasurements") private var showMeasurements = true
    @AppStorage("enableHapticFeedback") private var enableHapticFeedback = true
    @AppStorage("defaultSpacingUnit") private var defaultSpacingUnit = SpacingUnit.pixels
    @Environment(\.dismiss) private var dismiss
    @State private var showOnboardingResetAlert = false
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // App Header
                    appHeaderSection
                    
                    // Export Settings
                    exportSettingsSection
                    
                    // Display Settings
                    displaySettingsSection
                    
                    // App Information
                    appInfoSection
                    
                    // Support Section
                    supportSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
        .alert("Reset Onboarding", isPresented: $showOnboardingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset") {
                performOnboardingReset()
            }
        } message: {
            Text("This will show the welcome tutorial when you restart the app. You'll need to close and reopen the app to see the onboarding.")
        }
    }
    
    private var appHeaderSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(.neonGreen)
                .neonGlow(color: .neonGreen, intensity: 3)
            
            VStack(spacing: 12) {
                Text("BlinkRatio")
                    .font(NeonFont.largeTitle)
                    .foregroundColor(.white)
                    .neonGlow(color: .neonGreen, intensity: 2)
                
                Text("Design Reference & Tools")
                    .font(NeonFont.body)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Version 1.0.0")
                    .font(NeonFont.caption)
                    .foregroundColor(.neonGreen)
            }
        }
        .padding(24)
        .neonCard(borderColor: .neonGreen)
    }
    
    private var exportSettingsSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "Export Settings", icon: "square.and.arrow.up", color: .neonBlue)
            
            VStack(spacing: 16) {
                SettingsRow(
                    title: "Export Quality",
                    subtitle: "Image resolution for exports"
                ) {
                    Menu(exportQuality.rawValue) {
                        ForEach(ExportQuality.allCases, id: \.self) { quality in
                            Button(quality.rawValue) {
                                exportQuality = quality
                            }
                        }
                    }
                    .foregroundColor(.neonBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.neonSecondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Divider()
                    .overlay(Color.neonBlue.opacity(0.3))
                    .padding(.horizontal, 20)
                
                SettingsToggleRow(
                    title: "Include Measurements",
                    subtitle: "Show dimensions in exports",
                    isOn: $showMeasurements
                )
            }
        }
        .padding(24)
        .neonCard(borderColor: .neonBlue)
    }
    
    private var displaySettingsSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "Display Settings", icon: "display", color: .neonPink)
            
            VStack(spacing: 16) {
                SettingsRow(
                    title: "Default Unit",
                    subtitle: "Preferred measurement unit"
                ) {
                    Menu(defaultSpacingUnit.rawValue) {
                        ForEach(SpacingUnit.allCases, id: \.self) { unit in
                            Button(unit.rawValue) {
                                defaultSpacingUnit = unit
                            }
                        }
                    }
                    .foregroundColor(.neonPink)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.neonSecondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Divider()
                    .overlay(Color.neonPink.opacity(0.3))
                    .padding(.horizontal, 20)
                
                SettingsToggleRow(
                    title: "Haptic Feedback",
                    subtitle: "Vibration for interactions",
                    isOn: $enableHapticFeedback
                )
            }
        }
        .padding(24)
        .neonCard(borderColor: .neonPink)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "App Information", icon: "info.circle", color: .neonGreen)
            
            VStack(spacing: 12) {
                InfoRow(label: "Platform", value: "iOS 15.6+")
                InfoRow(label: "Build", value: "2025.01.18")
                InfoRow(label: "Framework", value: "SwiftUI")
                InfoRow(label: "Compatibility", value: "iPhone & iPad")
            }
        }
        .padding(24)
        .neonCard(borderColor: .neonGreen)
    }
    
    private var supportSection: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "Support", icon: "questionmark.circle", color: .neonBlue)
            
            VStack(spacing: 16) {
                ActionButton(
                    title: "Reset Onboarding",
                    subtitle: "View the welcome tutorial again",
                    icon: "arrow.counterclockwise",
                    color: .neonGreen
                ) {
                    resetOnboarding()
                }
                
                ActionButton(
                    title: "Reset All Settings",
                    subtitle: "Restore default preferences",
                    icon: "arrow.clockwise",
                    color: .neonPink
                ) {
                    resetSettings()
                }
                
                ActionButton(
                    title: "Clear All Data",
                    subtitle: "Remove favorites and cached data",
                    icon: "trash",
                    color: .neonPink
                ) {
                    clearAllData()
                }
            }
        }
        .padding(24)
        .neonCard(borderColor: .neonBlue)
    }
    
    private func resetSettings() {
        exportQuality = .high
        showMeasurements = true
        enableHapticFeedback = true
        defaultSpacingUnit = .pixels
        
        if enableHapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    private func resetOnboarding() {
        showOnboardingResetAlert = true
    }
    
    private func performOnboardingReset() {
        UserDefaults.standard.removeObject(forKey: "BlinkRatio_HasCompletedOnboarding")
        
        if enableHapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    private func clearAllData() {
        UserDefaults.standard.removeObject(forKey: "BlinkRatio_Favorites")
        
        if enableHapticFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
    }
}

// MARK: - Settings Components

struct SectionHeader: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .neonGlow(color: color, intensity: 2)
            
            Text(title)
                .font(NeonFont.headline)
                .foregroundColor(color)
                .neonGlow(color: color, intensity: 1)
            
            Spacer()
        }
    }
}

struct SettingsRow<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content
    
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(NeonFont.body)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(NeonFont.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        SettingsRow(title: title, subtitle: subtitle) {
            Toggle("", isOn: $isOn)
                .toggleStyle(NeonToggleStyle())
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(NeonFont.body)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(NeonFont.body)
                .foregroundColor(.neonGreen)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.neonSecondaryBackground.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(NeonFont.body)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(NeonFont.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(20)
            .background(Color.neonSecondaryBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(color.opacity(0.6), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Settings Enums

enum ExportQuality: String, CaseIterable {
    case low = "Low (1x)"
    case medium = "Medium (2x)"
    case high = "High (3x)"
    
    var scale: CGFloat {
        switch self {
        case .low: return 1.0
        case .medium: return 2.0
        case .high: return 3.0
        }
    }
}

enum SpacingUnit: String, CaseIterable {
    case pixels = "Pixels (px)"
    case points = "Points (pt)"
    case rems = "Rems (rem)"
    case ems = "Ems (em)"
}

#Preview {
    NavigationView {
        SettingsView()
    }
} 
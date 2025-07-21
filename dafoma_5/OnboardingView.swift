//
//  OnboardingView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

// MARK: - Onboarding Models
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let iconName: String
    let accentColor: Color
    let features: [String]
}

// MARK: - Onboarding State Manager
class OnboardingManager: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @StateObject private var onboardingManager = OnboardingManager()
    @State private var currentPage = 0
    @State private var animateIn = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to",
            subtitle: "BlinkRatio",
            description: "Your ultimate design reference companion for creating perfect layouts and proportions",
            iconName: "square.grid.2x2",
            accentColor: .neonGreen,
            features: ["Aspect Ratios", "Typography Scales", "Grid Systems", "Safe Zones"]
        ),
        OnboardingPage(
            title: "Design",
            subtitle: "Reference",
            description: "Access essential design foundations including visual ratios, typography scales, and grid systems",
            iconName: "rectangle.ratio.3.to.4",
            accentColor: .neonGreen,
            features: ["Golden Ratio", "16:9 Widescreen", "Typography Scale", "8pt Grid System"]
        ),
        OnboardingPage(
            title: "Design",
            subtitle: "Tools",
            description: "Powerful calculators and converters to help you work with ratios, units, spacing, and colors",
            iconName: "wrench.and.screwdriver",
            accentColor: .neonBlue,
            features: ["Ratio Calculator", "Unit Converter", "Spacing Calculator", "Color Tools"]
        ),
        OnboardingPage(
            title: "Favorites &",
            subtitle: "Export",
            description: "Save your frequently used references and export designs directly to your photo library",
            iconName: "heart.fill",
            accentColor: .neonPink,
            features: ["Save References", "Quick Access", "Export Images", "Photo Library"]
        )
    ]
    
    var body: some View {
        ZStack {
            Color.neonBackground
                .ignoresSafeArea()
            
            VStack {
                // Skip Button
                HStack {
                    Spacer()
                    Button("Skip") {
                        onboardingManager.completeOnboarding()
                    }
                    .font(NeonFont.body)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.trailing, 24)
                    .padding(.top, 16)
                }
                
                // Main Content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(page: page, isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Page Control and Navigation
                VStack(spacing: 32) {
                    // Custom Page Indicator
                    PageIndicatorView(currentPage: currentPage, totalPages: pages.count)
                    
                    // Navigation Buttons
                    navigationButtons
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateIn = true
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            // Previous Button
            if currentPage > 0 {
                Button("Previous") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage -= 1
                    }
                }
                .font(NeonFont.body)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.neonSecondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
            
            Spacer()
            
            // Next/Get Started Button
            Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                if currentPage == pages.count - 1 {
                    onboardingManager.completeOnboarding()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                }
            }
            .font(NeonFont.headline)
            .foregroundColor(.neonBackground)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(pages[currentPage].accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .neonGlow(color: pages[currentPage].accentColor, intensity: 3)
            .scaleEffect(animateIn ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateIn)
        }
    }
}

// MARK: - Individual Page View
struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Spacer(minLength: 40)
                
                // Icon Section
                VStack(spacing: 24) {
                    Image(systemName: page.iconName)
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundColor(page.accentColor)
                        .neonGlow(color: page.accentColor, intensity: 4)
                        .scaleEffect(animateContent ? 1.0 : 0.5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateContent)
                    
                    // Decorative Ring
                    Circle()
                        .stroke(page.accentColor.opacity(0.3), lineWidth: 2)
                        .frame(width: 160, height: 160)
                        .overlay(
                            Circle()
                                .stroke(page.accentColor.opacity(0.1), lineWidth: 40)
                        )
                        .scaleEffect(animateContent ? 1.0 : 0.8)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 1.0).delay(0.4), value: animateContent)
                }
                
                // Text Content
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text(page.title)
                            .font(NeonFont.title)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(page.subtitle)
                            .font(NeonFont.largeTitle)
                            .foregroundColor(page.accentColor)
                            .neonGlow(color: page.accentColor, intensity: 2)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
                    
                    Text(page.description)
                        .font(NeonFont.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.8), value: animateContent)
                }
                
                // Features Grid
                featuresGrid
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 32)
        }
        .onChange(of: isActive) { active in
            if active {
                animateContent = false
                withAnimation {
                    animateContent = true
                }
            }
        }
        .onAppear {
            if isActive {
                animateContent = true
            }
        }
    }
    
    private var featuresGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                FeatureCard(title: feature, accentColor: page.accentColor)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(1.0 + Double(index) * 0.1), value: animateContent)
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let title: String
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(NeonFont.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.neonSecondaryBackground.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentColor.opacity(0.4), lineWidth: 1)
        )
    }
}

// MARK: - Page Indicator
struct PageIndicatorView: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.neonGreen : Color.white.opacity(0.3))
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

// MARK: - Onboarding Wrapper
struct OnboardingWrapper: View {
    @StateObject private var onboardingManager = OnboardingManager()
    
    var body: some View {
        Group {
            if onboardingManager.hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingView()
                    .environmentObject(onboardingManager)
            }
        }
    }
}

#Preview {
    OnboardingView()
} 

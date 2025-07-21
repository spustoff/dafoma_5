//
//  MainView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = BlinkRatioViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.neonBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.referenceCards) { card in
                            NavigationLink(destination: destinationView(for: card.type)) {
                                ReferenceCardView(card: card)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("BlinkRatio")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .neonNavigationBar()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private func destinationView(for type: ReferenceCardType) -> some View {
        switch type {
        case .ratios:
            RatioCardsView()
        case .spacing:
            SpacingGridView()
        case .typography:
            TypographyScaleView()
        case .safeZones:
            SafeZonesView()
        case .gridSystems:
            GridSystemsView()
        }
    }
}

struct ReferenceCardView: View {
    let card: ReferenceCard
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon Section
            ZStack {
                Circle()
                    .fill(card.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: card.type.icon)
                    .font(.title)
                    .foregroundColor(card.color)
                    .neonGlow(color: card.color, intensity: 2)
            }
            
            // Text Section
            VStack(spacing: 8) {
                Text(card.title)
                    .font(NeonFont.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(card.subtitle)
                    .font(NeonFont.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .padding(20)
        .neonCard(borderColor: card.color)
    }
}

#Preview {
    MainView()
} 
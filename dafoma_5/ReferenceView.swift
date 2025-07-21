//
//  ReferenceView.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI

struct ReferenceView: View {
    @StateObject private var viewModel = BlinkRatioViewModel()
    
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
        .navigationTitle("Design Reference")
        .navigationBarTitleDisplayMode(.large)
        .neonNavigationBar()
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

#Preview {
    NavigationView {
        ReferenceView()
    }
} 
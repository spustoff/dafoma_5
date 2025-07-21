//
//  ViewModels.swift
//  BlinkRatio
//
//  Created by Вячеслав on 7/18/25.
//

import SwiftUI
import UIKit

// MARK: - Main View Model
@MainActor
class BlinkRatioViewModel: ObservableObject {
    @Published var referenceCards: [ReferenceCard] = []
    @Published var selectedCard: ReferenceCardType?
    
    init() {
        loadReferenceCards()
    }
    
    private func loadReferenceCards() {
        referenceCards = ReferenceCardType.allCases.map { ReferenceCard(type: $0) }
    }
    
    func selectCard(_ type: ReferenceCardType) {
        selectedCard = type
    }
    
    func deselectCard() {
        selectedCard = nil
    }
}

// MARK: - Export Helper
class ExportHelper {
    @MainActor
    static func exportViewAsPNG<V: View>(_ view: V, fileName: String = "BlinkRatio_Export") {
        if let uiImage = renderViewAsImage(view) {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
    }
    
    @MainActor
    static func renderViewAsImage<V: View>(_ view: V) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        let targetSize = CGSize(width: 375, height: 812) // iPhone size
        
        controller.view.bounds = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = UIColor.clear
        controller.view.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { context in
            controller.view.layer.render(in: context.cgContext)
        }
    }
} 
//
//  BarsVisibilityModifier.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 18.03.2026.
//

import SwiftUI

// MARK: - BarsVisibilityModifier

/// Модификатор для скрытия/показа NavigationBar и TabBar
struct BarsVisibilityModifier: ViewModifier {
    let hidden: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar(hidden ? .hidden : .visible, for: .navigationBar)
            .toolbar(hidden ? .hidden : .visible, for: .tabBar)
    }
}

// MARK: - View Extension

extension View {
    /// Упрощенный вызов модификатора для скрытия баров
    func barsVisibility(hidden: Bool) -> some View {
        modifier(BarsVisibilityModifier(hidden: hidden))
    }
}

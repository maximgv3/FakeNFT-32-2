//
//  CartSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

/// Варианты сортировки товаров в корзине
enum CartSortOption: String, CaseIterable {
    
    /// Сортировка по цене (от меньшей к большей)
    case price
    
    /// Сортировка по рейтингу (от высшего к низшему)
    case rating
    
    /// Сортировка по названию (в алфавитном порядке)
    case name
    
    /// Локализованное название опции сортировки для отображения в интерфейсе
    var title: String {
        switch self {
        case .price:
            return "По цене"
        case .rating:
            return "По рейтингу"
        case .name:
            return "По названию"
        }
    }
}

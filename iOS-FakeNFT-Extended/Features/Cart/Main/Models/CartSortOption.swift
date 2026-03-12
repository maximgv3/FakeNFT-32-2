//
//  CartSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

enum CartSortOption: String, CaseIterable {
    case price
    case rating
    case name
    
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

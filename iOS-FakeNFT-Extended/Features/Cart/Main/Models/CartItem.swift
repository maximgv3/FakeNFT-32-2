//
//  CartItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let rating: Int
    let imageURL: URL?

    var priceText: String {
        "\(String(format: "%.2f", price).replacingOccurrences(of: ".", with: ",")) ETH"
    }
}

extension CartItem {
    static let mock1 = CartItem(
        id: "1",
        name: "Ore",
        price: 3.24,
        rating: 5,
        imageURL: nil
    )

    static let mock2 = CartItem(
        id: "2",
        name: "Moon",
        price: 1.40,
        rating: 4,
        imageURL: nil
    )

    static let mock3 = CartItem(
        id: "3",
        name: "Meta",
        price: 7.90,
        rating: 3,
        imageURL: nil
    )

    static let mockItems: [CartItem] = [
        .mock1,
        .mock2,
        .mock3
    ]
}

//
//  CartItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import Foundation

/// Модель элемента корзины с NFT товаром
struct CartItem: Identifiable, Hashable {
    
    /// Уникальный идентификатор товара
    let id: String
    
    /// Название NFT
    let name: String
    
    /// Цена товара в ETH
    let price: Double
    
    /// Рейтинг товара от 1 до 5
    let rating: Int
    
    /// URL изображения NFT для загрузки и отображения
    let imageURL: URL?

    /// Отформатированная строка цены для отображения в интерфейсе
    /// Формат: "X,XX ETH" (с запятой в качестве десятичного разделителя)
    var priceText: String {
        "\(String(format: "%.2f", price).replacingOccurrences(of: ".", with: ",")) ETH"
    }
}

// MARK: - Mock Data
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

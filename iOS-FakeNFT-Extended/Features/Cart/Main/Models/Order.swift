//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

/// Модель заказа, получаемая с сервера
struct Order: Decodable {
    
    /// Уникальный идентификатор заказа
    let id: String
    
    /// Массив идентификаторов NFT, добавленных в корзину
    let nfts: [String]
}

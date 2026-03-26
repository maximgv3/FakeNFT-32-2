//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

protocol CartServiceProtocol: Sendable {
    func loadCartItems() async throws -> ([CartItem], orderId: String)
    func removeItem(id: String) async throws -> ([CartItem], orderId: String)
}

//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

final class MockCartService: CartService {
    func loadCartItems() async throws -> [CartItem] {
        CartItem.mockItems
    }
}

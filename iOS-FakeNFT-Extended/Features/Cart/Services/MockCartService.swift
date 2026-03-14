//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

actor MockCartService: CartServiceProtocol {
    func loadCartItems() async throws -> [CartItem] {
        CartItem.mockItems
    }
}

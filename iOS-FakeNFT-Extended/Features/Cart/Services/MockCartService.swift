//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

actor MockCartService: CartServiceProtocol {
    private var items = CartItem.mockItems

    func loadCartItems() async throws -> [CartItem] {
        items
    }

    func removeItem(id: String) async throws -> [CartItem] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }

        return items
    }
}

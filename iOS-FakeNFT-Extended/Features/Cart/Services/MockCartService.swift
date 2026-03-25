//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

actor MockCartService: CartServiceProtocol {
    private var items = CartItem.mockItems
    private let mockOrderId = "mock-order-id-123"
    
    func loadCartItems() async throws -> ([CartItem], orderId: String) {
        return (items, mockOrderId)
    }
    
    func removeItem(id: String) async throws -> ([CartItem], orderId: String) {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }
        
        return (items, mockOrderId)
    }
}

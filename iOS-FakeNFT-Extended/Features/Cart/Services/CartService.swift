//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

protocol CartService {
    func loadCartItems() async throws -> [CartItem]
}

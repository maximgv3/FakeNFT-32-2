//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 10.03.2026.
//

import Foundation
import Observation

@Observable
final class CartViewModel {
    
    var items: [CartItem] = []
    var isLoading = false
    var isRefreshing = false
    var errorMessage: String?
    
    private let cartService: CartService
    
    init(cartService: CartService) {
        self.cartService = cartService
    }
    
    var state: CartViewState {
        if isLoading && items.isEmpty {
            return .loading
        }
        
        if let errorMessage, items.isEmpty {
            return .error(errorMessage)
        }
        
        if items.isEmpty {
            return .empty
        }
        
        return .content
    }
    
    @MainActor
    func load() async {
        guard items.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            items = try await cartService.loadCartItems()
        } catch {
            errorMessage = "Не удалось загрузить корзину"
            print("Cart load error: \(error)")
        }
    }
    
    @MainActor
    func refresh() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        defer { isRefreshing = false }
        
        do {
            let updatedItems = try await cartService.loadCartItems()
            items = updatedItems
            errorMessage = nil
        } catch {
            print("Cart refresh error: \(error)")
        }
    }
}

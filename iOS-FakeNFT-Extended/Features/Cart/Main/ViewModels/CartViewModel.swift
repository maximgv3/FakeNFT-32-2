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
    
    var state: CartViewState {
        if isLoading && items.isEmpty {
            return .loading
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
        defer { isLoading = false }
        
        do {
            try await Task.sleep(for: .seconds(1.2))
            items = CartItem.mockItems
        } catch {
            items = []
        }
    }
    
    @MainActor
    func refresh() async {
        do {
            try await Task.sleep(for: .seconds(1.2))
            items = CartItem.mockItems
        } catch {
            // Во время pull-to-refresh не сбрасываем текущие данные,
            // чтобы список не исчезал при ошибке обновления.
        }
    }
}

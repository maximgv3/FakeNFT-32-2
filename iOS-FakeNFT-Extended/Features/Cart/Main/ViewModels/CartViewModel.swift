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
    var selectedSort: CartSortOption = .price
    
    private let cartService: CartService
    
    private enum Constants {
        static let selectedSortKey = "cart_selected_sort"
    }
    
    init(cartService: CartService) {
        self.cartService = cartService
        
        if let rawValue = UserDefaults.standard.string(forKey: Constants.selectedSortKey),
           let savedSort = CartSortOption(rawValue: rawValue) {
            selectedSort = savedSort
        }
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
    
    // MARK: - Sorting
    
    @MainActor
    func applySort(_ option: CartSortOption) {
        selectedSort = option
        
        UserDefaults.standard.set(
            option.rawValue,
            forKey: Constants.selectedSortKey
        )
        
        items = sortedItems(items, by: option)
    }
    
    private func sortedItems(_ items: [CartItem], by option: CartSortOption) -> [CartItem] {
        switch option {
        case .price:
            return items.sorted { $0.price < $1.price }
            
        case .rating:
            return items.sorted { $0.rating > $1.rating }
            
        case .name:
            return items.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    
    // MARK: - Load
    
    @MainActor
    func load() async {
        guard items.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let loadedItems = try await cartService.loadCartItems()
            items = sortedItems(loadedItems, by: selectedSort)
        } catch {
            errorMessage = "Не удалось загрузить корзину"
            print("Cart load error: \(error)")
        }
    }
    
    // MARK: - Refresh
    
    @MainActor
    func refresh() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        defer { isRefreshing = false }
        
        do {
            let updatedItems = try await cartService.loadCartItems()
            items = sortedItems(updatedItems, by: selectedSort)
            errorMessage = nil
        } catch {
            print("Cart refresh error: \(error)")
        }
    }
}

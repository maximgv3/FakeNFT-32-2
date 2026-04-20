//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 10.03.2026.
//

import Foundation
import Observation

private enum Constants {
    static let selectedSortKey = "cart_selected_sort"
}

@Observable
final class CartViewModel {
    
    // MARK: - Public Properties
    
    var items: [CartItem] = []
    var orderId: String = ""
    var isLoading = false
    var isRefreshing = false
    var errorMessage: String?
    var selectedSort: CartSortOption = .name
    var itemPendingRemoval: CartItem?
    var isDeleting = false
    
    // MARK: - Private Properties
    
    private let cartService: CartServiceProtocol
    private var loadTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    
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
        
        return .success
    }
    
    // MARK: - Init
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService

        if let rawValue = UserDefaults.standard.string(forKey: Constants.selectedSortKey),
           let savedSort = CartSortOption(rawValue: rawValue) {
            selectedSort = savedSort
        }

        Task { @MainActor in
            for await _ in NotificationCenter.default.notifications(named: .cartDidUpdate) {
                await self.refresh()
            }
        }
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func applySort(_ option: CartSortOption) {
        selectedSort = option
        UserDefaults.standard.set(option.rawValue, forKey: Constants.selectedSortKey)
        items = sortedItems(items, by: option)
    }
    
    @MainActor
    func load() async {
        guard items.isEmpty else { return }
        
        // ✅ Отменяем предыдущую загрузку
        loadTask?.cancel()
        
        loadTask = Task {
            isLoading = true
            errorMessage = nil
            
            defer { isLoading = false }
            
            do {
                let (loadedItems, loadedOrderId) = try await cartService.loadCartItems()
                try Task.checkCancellation()  // ✅ Проверяем отмену
                items = sortedItems(loadedItems, by: selectedSort)
                orderId = loadedOrderId
                print("📦 Cart loaded, orderId: \(orderId)")
            } catch is CancellationError {
                print("Cart loading cancelled")
            } catch {
                errorMessage = "Не удалось загрузить корзину"
                print("Cart load error: \(error)")
            }
        }
        
        await loadTask?.value
    }
    
    @MainActor
    func refresh() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        defer { isRefreshing = false }
        
        do {
            let (updatedItems, updatedOrderId) = try await cartService.loadCartItems()
            items = sortedItems(updatedItems, by: selectedSort)
            orderId = updatedOrderId
            errorMessage = nil
            print("📦 Cart refreshed, orderId: \(orderId)")
        } catch {
            print("Cart refresh error: \(error)")
        }
    }
    
    @MainActor
    func didTapRemove(on item: CartItem) {
        itemPendingRemoval = item
    }
    
    @MainActor
    func cancelRemoval() {
        itemPendingRemoval = nil
    }
    
    @MainActor
    func confirmRemoval() async {
        guard let item = itemPendingRemoval else { return }
        
        // Оптимистичное обновление UI
        let oldItems = items
        items.removeAll { $0.id == item.id }
        itemPendingRemoval = nil
        isDeleting = true
        
        do {
            // ✅ Получаем обновленные данные с сервера
            let (updatedItems, updatedOrderId) = try await cartService.removeItem(id: item.id)
            
            // ✅ Синхронизируем с сервером
            items = sortedItems(updatedItems, by: selectedSort)
            orderId = updatedOrderId
            errorMessage = nil
            print("🗑️ Item removed, new orderId: \(orderId)")
        } catch {
            // ✅ Откат при ошибке
            items = oldItems
            errorMessage = "Не удалось удалить товар"
            print("Cart remove error: \(error)")
        }
        
        isDeleting = false
    }
    
    // MARK: - Private Methods
    
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
}

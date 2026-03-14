//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 10.03.2026.
//

import Foundation
import Observation

// MARK: - Constants

private enum Constants {
    /// Ключ для сохранения выбранного способа сортировки в UserDefaults
    static let selectedSortKey = "cart_selected_sort"
}

// MARK: - CartViewModel

@Observable
final class CartViewModel {
    
    // MARK: - Public Properties
    
    /// Список товаров в корзине
    var items: [CartItem] = []
    
    /// Флаг первичной загрузки
    var isLoading = false
    
    /// Флаг обновления (pull-to-refresh)
    var isRefreshing = false
    
    /// Сообщение об ошибке, если произошла
    var errorMessage: String?
    
    /// Текущий выбранный способ сортировки
    var selectedSort: CartSortOption = .name
    
    // MARK: - Private Properties
    
    private let cartService: CartServiceProtocol
    
    // MARK: - Computed Properties
    
    /// Текущее состояние экрана на основе данных
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
    }
    
    // MARK: - Public Methods
    
    /// Применить сортировку к списку товаров
    /// - Parameter option: Выбранный способ сортировки
    @MainActor
    func applySort(_ option: CartSortOption) {
        selectedSort = option
        
        UserDefaults.standard.set(
            option.rawValue,
            forKey: Constants.selectedSortKey
        )
        
        items = sortedItems(items, by: option)
    }
    
    /// Загрузить товары в корзину
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
    
    /// Обновить список товаров (pull-to-refresh)
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
    
    // MARK: - Private Methods
    
    /// Отсортировать товары по выбранному критерию
    /// - Parameters:
    ///   - items: Исходный массив товаров
    ///   - option: Критерий сортировки
    /// - Returns: Отсортированный массив
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

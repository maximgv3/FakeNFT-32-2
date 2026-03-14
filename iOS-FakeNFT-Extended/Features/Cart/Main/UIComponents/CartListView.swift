//
//  CartListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

// MARK: - CartListView

struct CartListView: View {
    
    // MARK: - Properties
    
    /// Список товаров для отображения
    let items: [CartItem]
    
    /// Действие при нажатии на кнопку удаления
    let onRemove: (CartItem) -> Void
    
    /// Действие при обновлении списка (pull-to-refresh)
    let onRefresh: () async -> Void
    
    // MARK: - Body
    
    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                CartCell(
                    cartItem: item,
                    removeAction: {
                        onRemove(item)
                    }
                )
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: index == 0 ? 20 : 8,
                        leading: 16,
                        bottom: 8,
                        trailing: 16
                    )
                )
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color("ypWhite"))
        .refreshable {
            await onRefresh()
        }
    }
}

// MARK: - Preview

#Preview {
    CartListView(
        items: CartItem.mockItems,
        onRemove: { _ in },
        onRefresh: { }
    )
}

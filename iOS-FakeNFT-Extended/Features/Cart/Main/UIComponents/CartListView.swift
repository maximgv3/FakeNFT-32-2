//
//  CartListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartListView: View {
    let items: [CartItem]
    let onRemove: (CartItem) -> Void
    let onRefresh: () async -> Void
    
    var body: some View {
        List {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                CartCell(cartItem: item) {
                    onRemove(item)
                }
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

#Preview {
    CartListView(
        items: CartItem.mockItems,
        onRemove: { _ in },
        onRefresh: { }
    )
}

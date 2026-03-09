//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartView: View {
    let items: [CartItem]
    
    private var total: Double {
        items.map(\.price).reduce(0, +)
    }
    
    var body: some View {
        Group {
            if items.isEmpty {
                CartEmptyStateView()
            } else {
                CartListView(
                    items: items,
                    onRemove: { _ in }
                )
                .safeAreaInset(edge: .bottom) {
                    CartFooterView(
                        totalCount: items.count,
                        totalPrice: total,
                        payAction: { }
                    )
                }
            }
        }
        .background(Color("ypWhite"), ignoresSafeAreaEdges: .all)
    }
}

#Preview("Filled") {
    NavigationStack {
        CartView(items: CartItem.mockItems)
    }
}

#Preview("Empty") {
    NavigationStack {
        CartView(items: [])
    }
}

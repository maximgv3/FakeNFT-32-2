//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel = CartViewModel()
    
    private var total: Double {
        viewModel.items.map(\.price).reduce(0, +)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
                
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .empty:
                CartEmptyStateView()
                
            case .content:
                CartListView(
                    items: viewModel.items,
                    onRemove: { _ in },
                    onRefresh: {
                        await viewModel.refresh()
                    }
                    
                )
                .safeAreaInset(edge: .bottom) {
                    CartFooterView(
                        totalCount: viewModel.items.count,
                        totalPrice: total,
                        payAction: { }
                    )
                }
            }
        }
        .background(Color("ypWhite"), ignoresSafeAreaEdges: .all)
        .task {
            await viewModel.load()
        }
    }
}

#Preview("Filled after loading") {
    NavigationStack {
        CartView()
    }
}

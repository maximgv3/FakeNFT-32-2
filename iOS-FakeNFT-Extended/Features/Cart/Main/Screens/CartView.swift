//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var isSortDialogPresented = false
    
    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
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
                
            case .error(let message):
                VStack(spacing: 12) {
                    Text(message)
                        .multilineTextAlignment(.center)
                    
                    Button("Повторить") {
                        Task {
                            await viewModel.load()
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color("ypWhite"), ignoresSafeAreaEdges: .all)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSortDialogPresented = true
                } label: {
                    Image("sort")
                        .renderingMode(.template)
                        .foregroundStyle(Color("ypBlack"))
                }
            }
        }
        .confirmationDialog(
            "Сортировка",
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            Button("По цене") {
                viewModel.applySort(.price)
            }
            
            Button("По рейтингу") {
                viewModel.applySort(.rating)
            }
            
            Button("По названию") {
                viewModel.applySort(.name)
            }
            
            Button("Закрыть", role: .cancel) { }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview("Filled Cart") {
    NavigationStack {
        CartView(
            viewModel: CartViewModel(cartService: MockCartService())
        )
    }
}

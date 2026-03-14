//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

// MARK: - CartView

struct CartView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: CartViewModel
    @State private var isSortDialogPresented = false
    
    // MARK: - Init
    
    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Computed Properties
    
    private var total: Double {
        viewModel.items.map(\.price).reduce(0, +)
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
                
            case .empty:
                emptyView
                
            case .success:
                contentView
                
            case .error(let message):
                errorView(message)
            }
        }
        .background(backgroundView, ignoresSafeAreaEdges: .all)
        .toolbar { sortToolbar }
        .confirmationDialog(
            "Сортировка",
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            sortDialog
        }
        .task {
            await viewModel.load()
        }
    }
    
    // MARK: - Views
    
    private var loadingView: some View {
        SkeletonCartView()
    }
    
    private var emptyView: some View {
        CartEmptyStateView()
    }
    
    private var contentView: some View {
        CartListView(
            items: viewModel.items,
            onRemove: { _ in },
            onRefresh: {
                await viewModel.refresh()
            }
        )
        .safeAreaInset(edge: .bottom) {
            footerView
        }
    }
    
    private func errorView(_ message: String) -> some View {
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
    
    private var footerView: some View {
        CartFooterView(
            totalCount: viewModel.items.count,
            totalPrice: total,
            payAction: { }
        )
    }
    
    private var backgroundView: Color {
        Color("ypWhite")
    }
    
    // MARK: - Toolbar
    
    private var sortToolbar: some ToolbarContent {
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
    
    // MARK: - Dialog
    
    private var sortDialog: some View {
        Group {
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
    }
}

// MARK: - Preview

#Preview("Filled Cart") {
    NavigationStack {
        CartView(
            viewModel: CartViewModel(cartService: MockCartService())
        )
    }
}

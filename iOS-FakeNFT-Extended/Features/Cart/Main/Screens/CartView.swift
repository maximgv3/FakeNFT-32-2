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
    @State private var showPayment = false
    
    // MARK: - Init
    
    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Computed Properties
    
    private var total: Double {
        viewModel.items.map(\.price).reduce(0, +)
    }
    
    private var isDeleteConfirmationPresented: Bool {
        viewModel.itemPendingRemoval != nil
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            stateView
            deleteOverlayView
        }
        .animation(.easeInOut(duration: 0.2), value: isDeleteConfirmationPresented)
        .background(backgroundView.ignoresSafeArea())
        .barsVisibility(hidden: isDeleteConfirmationPresented)
        .toolbar {
            if !isDeleteConfirmationPresented {
                sortToolbar
            }
        }
        .confirmationDialog(
            "Сортировка",
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            sortDialog
        }
        .navigationDestination(isPresented: $showPayment) {
            PaymentView()
                .toolbar(.hidden, for: .tabBar)
                .toolbarBackground(.hidden, for: .tabBar)
        }
        .task {
            await viewModel.load()
        }
    }
    
    // MARK: - State View
    
    @ViewBuilder
    private var stateView: some View {
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
    }
    
    // MARK: - Delete Overlay
    
    @ViewBuilder
    private var deleteOverlayView: some View {
        if let item = viewModel.itemPendingRemoval {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.16))
                .transition(.opacity)
            
            DeleteCartItemView(
                item: item,
                isDeleting: viewModel.isDeleting,
                onDelete: {
                    Task { await viewModel.confirmRemoval() }
                },
                onCancel: {
                    viewModel.cancelRemoval()
                }
            )
            .transition(.scale(scale: 0.96).combined(with: .opacity))
            .zIndex(1)
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
            onRemove: { item in
                viewModel.didTapRemove(on: item)
            },
            onRefresh: {
                await viewModel.refresh()
            }
        )
        .safeAreaInset(edge: .bottom) {
            if !isDeleteConfirmationPresented {
                footerView
            }
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
            payAction: { showPayment = true }
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

#Preview("Delete Confirmation") {
    let viewModel = CartViewModel(cartService: MockCartService())
    viewModel.itemPendingRemoval = .mock1
    
    return NavigationStack {
        CartView(viewModel: viewModel)
    }
}

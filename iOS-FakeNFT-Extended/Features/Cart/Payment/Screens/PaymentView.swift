//
//  PaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 15.03.2026.
//

import SwiftUI

struct PaymentView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PaymentViewModel
    
    @State private var showingAgreement = false
    @State private var showSuccess = false
    @State private var showPaymentError = false
    @State private var errorMessage = ""
    
    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")!
    private let onSuccess: () -> Void
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    // MARK: - Init
    
    init(networkClient: NetworkClient, onSuccess: @escaping () -> Void) {
        _viewModel = State(initialValue: PaymentViewModel(networkClient: networkClient))
        self.onSuccess = onSuccess
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            paymentMethodsGrid
                .padding(.horizontal, 16)
                .padding(.top, 16)
        }
        .safeAreaInset(edge: .bottom) {
            footerView
        }
        .background(backgroundView.ignoresSafeArea())
        .navigationTitle("Выберите способ оплаты")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCurrencies()
        }
        .navigationDestination(isPresented: $showingAgreement) {
            WebView(url: agreementURL)
                .navigationTitle("Пользовательское соглашение")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationDestination(isPresented: $showSuccess) {
            PaymentSuccessView {
                dismiss()
                onSuccess()
            }
        }
        .alert(
            "Не удалось произвести оплату",
            isPresented: $showPaymentError,
            actions: {
                Button("Отмена", role: .cancel) {
                    // Просто закрываем алерт, остаемся на экране оплаты
                    showPaymentError = false
                    viewModel.reset()
                }
                
                Button("Повторить") {
                    showPaymentError = false
                    Task {
                        await viewModel.retry()
                    }
                }
            },
            message: {
                Text(errorMessage)
            }
        )
        .onChange(of: viewModel.state) { oldState, newState in
            handleStateChange(newState)
        }
        .onDisappear {
            viewModel.reset()
        }
    }
    
    // MARK: - Views
    
    private var paymentMethodsGrid: some View {
        LazyVGrid(columns: columns, spacing: 7) {
            ForEach(viewModel.paymentMethods) { method in
                PaymentMethodCell(
                    method: method,
                    isSelected: viewModel.selectedMethodID == method.id
                )
                .onTapGesture {
                    viewModel.selectedMethodID = method.id
                }
            }
        }
    }
    
    private var footerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            agreementView
            payButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(footerBackground)
    }
    
    private var agreementView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Совершая покупку, вы соглашаетесь с условиями")
                .font(.system(size: 13))
                .foregroundStyle(Color("ypBlack"))
            
            Button {
                showingAgreement = true
            } label: {
                Text("Пользовательского соглашения")
                    .font(.system(size: 13))
                    .foregroundStyle(Color("ypUBlue"))
            }
        }
    }
    
    private var payButton: some View {
        Button {
            Task {
                await viewModel.pay()
            }
        } label: {
            ZStack {
                if viewModel.state == .loading {
                    HStack(spacing: 8) {
                        ProgressView()
                            .tint(.ypWhite)
                        Text("Оплата...")
                            .font(.system(size: 17, weight: .bold))
                    }
                } else {
                    Text("Оплатить")
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .foregroundStyle(Color("ypWhite"))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(buttonBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .animation(.easeInOut(duration: 0.2), value: viewModel.state == .loading)
        }
        .disabled(
            viewModel.selectedMethodID == nil ||
            viewModel.state == .loading
        )
    }
    
    private var buttonBackgroundColor: Color {
        if viewModel.selectedMethodID == nil {
            return Color.gray
        } else if viewModel.state == .loading {
            return Color.gray
        } else {
            return Color("ypBlack")
        }
    }
    
    private var footerBackground: some View {
        Color("ypLightGrey")
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 12
                )
            )
            .ignoresSafeArea(edges: .bottom)
    }
    
    private var backgroundView: Color {
        Color("ypWhite")
    }
    
    // MARK: - Private Methods
    
    private func handleStateChange(_ newState: PaymentViewModel.State) {
        switch newState {
        case .success:
            showSuccess = true
        case .error(let message):
            errorMessage = message
            showPaymentError = true
        default:
            break
        }
    }
}

#Preview {
    NavigationStack {
        PaymentView(
            networkClient: DefaultNetworkClient(),
            onSuccess: { }
        )
    }
    .preferredColorScheme(.light)
}

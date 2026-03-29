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
    
    private let agreementURLString = "https://yandex.ru/legal/practicum_termsofuse/"
    private let onSuccess: () -> Void
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    // MARK: - Computed Properties
    
    private var agreementURL: URL? {
        URL(string: agreementURLString)
    }
    
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
        .background(Color("ypWhite").ignoresSafeArea())
        .navigationTitle("Выберите способ оплаты")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadCurrencies()
        }
        .onChange(of: viewModel.isSuccess) { _, newValue in
            showSuccess = newValue
        }
        .navigationDestination(isPresented: $showSuccess) {
            PaymentSuccessView {
                dismiss()
                onSuccess()
            }
        }
        .navigationDestination(isPresented: $showingAgreement) {
            if let url = agreementURL {
                WebView(url: url)
                    .navigationTitle("Пользовательское соглашение")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                // fallback на случай, если URL невалидный
                Text("Не удалось загрузить соглашение")
            }
        }
        .alert(
            "Не удалось произвести оплату",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.resetError() } }
            ),
            actions: {
                Button("Отмена", role: .cancel) {
                    viewModel.resetError()
                }
                
                Button("Повторить") {
                    Task {
                        await viewModel.retry()
                    }
                }
            },
            message: {
                Text(viewModel.errorMessage ?? "")
            }
        )
        .onDisappear {
            if !showSuccess {
                viewModel.reset()
            }
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
            .disabled(agreementURL == nil)  // блокируем кнопку, если URL невалидный
        }
    }
    
    private var payButton: some View {
        Button {
            Task {
                await viewModel.pay()
            }
        } label: {
            ZStack {
                if viewModel.isLoading {
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
            .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
        }
        .disabled(!viewModel.canPay)
    }
    
    private var buttonBackgroundColor: Color {
        if viewModel.canPay {
            return Color("ypBlack")
        } else {
            return Color.gray
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

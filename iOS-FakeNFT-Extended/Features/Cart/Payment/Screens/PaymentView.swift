//
//  PaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 15.03.2026.
//

import SwiftUI

// MARK: - PaymentView

struct PaymentView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMethodID: String?
    @State private var showingAgreement = false
    
    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_termsofuse/")!
    private let methods = PaymentMethod.mock 
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
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
        .navigationDestination(isPresented: $showingAgreement) {
            WebView(url: agreementURL)
                .navigationTitle("Пользовательское соглашение")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Views
    
    private var paymentMethodsGrid: some View {
        LazyVGrid(columns: columns, spacing: 7) {
            ForEach(methods) { method in
                PaymentMethodCell(
                    method: method,
                    isSelected: selectedMethodID == method.id
                )
                .onTapGesture {
                    selectedMethodID = method.id
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
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color("ypBlack"))
            
            Button {
                showingAgreement = true
            } label: {
                Text("Пользовательского соглашения")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color("ypUBlue"))
            }
        }
    }
    
    private var payButton: some View {
        Button {
            // TODO: - Обработка оплаты
        } label: {
            Text("Оплатить")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color("ypWhite"))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color("ypBlack"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PaymentView()
    }
    .preferredColorScheme(.light)
}

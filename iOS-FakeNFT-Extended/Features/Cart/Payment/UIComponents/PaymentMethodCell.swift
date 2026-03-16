//
//  PaymentMethodCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 15.03.2026.
//

import SwiftUI

struct PaymentMethodCell: View {
    
    // MARK: - Properties
    
    let method: PaymentMethod
    let isSelected: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 8) {
            methodImage
            methodInfo
            Spacer()
        }
        .padding(.horizontal, 8)
        .frame(height: 46)
        .background(Color("ypLightGrey"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(selectionBorder)
    }
    
    // MARK: - Private Views
    
    private var methodImage: some View {
        method.image
            .resizable()
            .scaledToFill()
            .frame(width: 36, height: 36)
            .background(Color("ypBlack"))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    private var methodInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(method.title)
                .font(.system(size: 13))
                .foregroundStyle(Color("ypBlack"))
            
            Text(method.code)
                .font(.system(size: 13))
                .foregroundStyle(Color("ypUGreen"))
        }
    }
    
    @ViewBuilder
    private var selectionBorder: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("ypBlack"), lineWidth: 1)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 10) {
        PaymentMethodCell(
            method: PaymentMethod(
                id: "1",
                title: "Bitcoin",
                code: "BTC",
                image: Image("BTC")
            ),
            isSelected: false
        )
        
        PaymentMethodCell(
            method: PaymentMethod(
                id: "2",
                title: "Ethereum",
                code: "ETH",
                image: Image("ETH")
            ),
            isSelected: true
        )
    }
    .padding()
    .background(Color("ypWhite"))
}

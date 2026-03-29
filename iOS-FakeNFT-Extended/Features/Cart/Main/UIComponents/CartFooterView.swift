//
//  CartFooterView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartFooterView: View {
    let totalCount: Int
    let totalPrice: Double
    let payAction: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(totalCount) NFT")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color("ypBlack"))
                    .lineLimit(1)
                
                HStack(spacing: 0) {
                    Text(
                        String(format: "%.2f", totalPrice)
                            .replacingOccurrences(of: ".", with: ",")
                    )
                    Text(" ETH")
                }
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color("ypUGreen"))
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button("К оплате", action: payAction)
                .buttonStyle(PrimaryButtonStyle())
                .frame(width: 240, height: 44)
        }
        .padding(.horizontal, 16)
        .frame(height: 76)
        .background(Color("ypLightGrey"))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
        )
        .padding(.horizontal, 0)
        .padding(.bottom, 0)
        .background(Color.clear)
    }
}

#Preview {
    VStack {
        Spacer()
        CartFooterView(
            totalCount: 3,
            totalPrice: 5.34,
            payAction: { }
        )
    }
    .background(Color("ypWhite"))
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color("ypWhite"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("ypBlack"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

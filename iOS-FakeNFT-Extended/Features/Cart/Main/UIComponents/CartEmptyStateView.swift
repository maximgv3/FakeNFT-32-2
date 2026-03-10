//
//  CartEmptyStateView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 08.03.2026.
//

import SwiftUI

struct CartEmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Корзина пуста")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color("ypBlack"))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("ypWhite"))
    }
}

#Preview {
    CartEmptyStateView()
}

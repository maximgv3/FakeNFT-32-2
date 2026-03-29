//
//  PaymentSuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 24.03.2026.
//

import SwiftUI

struct PaymentSuccessView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(.success)
                .resizable()
                .scaledToFit()
                .frame(width: 278, height: 278)
            
            Text("Успех! Оплата прошла,\nпоздравляем с покупкой")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("ypBlack"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            Spacer()
            
            Button(action: action) {
                Text("Вернуться в корзину")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color("ypWhite"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color("ypBlack"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color("ypWhite"))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        PaymentSuccessView(action: {})
    }
}

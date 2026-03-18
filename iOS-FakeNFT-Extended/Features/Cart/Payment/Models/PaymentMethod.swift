//
//  PaymentMethod.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 15.03.2026.
//

import Foundation

struct PaymentMethod: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let code: String
    let imageName: String
    
    // Для Hashable
    static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Mock Data
extension PaymentMethod {
    static let mock: [PaymentMethod] = [
        PaymentMethod(id: "1", title: "Bitcoin", code: "BTC", imageName: "BTC"),
        PaymentMethod(id: "2", title: "Dogecoin", code: "DOGE", imageName: "DOGE"),
        PaymentMethod(id: "3", title: "Tether", code: "USDT", imageName: "USDT"),
        PaymentMethod(id: "4", title: "Apecoin", code: "APE", imageName: "APE"),
        PaymentMethod(id: "5", title: "Solana", code: "SOL", imageName: "SOL"),
        PaymentMethod(id: "6", title: "Ethereum", code: "ETH", imageName: "ETH"),
        PaymentMethod(id: "7", title: "Cardano", code: "ADA", imageName: "ADA"),
        PaymentMethod(id: "8", title: "Shiba Inu", code: "SHIB", imageName: "SHIB")
    ]
    
    static let mockSingle = PaymentMethod(
        id: "1",
        title: "Bitcoin",
        code: "BTC",
        imageName: "BTC"
    )
}

//
//  PaymentResponse.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 23.03.2026.
//

struct PaymentResponse: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}

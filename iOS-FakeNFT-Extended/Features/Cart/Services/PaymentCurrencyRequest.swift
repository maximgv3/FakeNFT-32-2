//
//  PaymentCurrencyRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 25.03.2026.
//

import Foundation

/// Запрос на оплату заказа выбранной валютой
struct PaymentCurrencyRequest: NetworkRequest {
    let currencyId: String
    
    var httpMethod: HttpMethod { .get }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
    
    var body: Data? { nil }
}

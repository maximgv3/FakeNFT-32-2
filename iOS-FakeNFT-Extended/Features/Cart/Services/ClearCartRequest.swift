//
//  ClearCartRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 25.03.2026.
//

import Foundation

/// Запрос на очистку корзины после оплаты
struct ClearCartRequest: NetworkRequest {
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var body: Data? {
        Data()
    }
}

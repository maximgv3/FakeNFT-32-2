//
//  CurrenciesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 24.03.2026.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    
    var httpMethod: HttpMethod { .get }
}

// Модель для ответа от сервера
struct CurrencyResponse: Decodable {
    let id: String
    let title: String
    let name: String  // Это будет code
    let image: String // Не используем, но нужно для декодирования
}

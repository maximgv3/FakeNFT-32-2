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
    
    var dto: Data? {
        // ✅ Отправляем пустой массив в формате nfts[]
        let params: [String: String] = [:]
        
        // Пустой массив — не добавляем параметров или добавляем nfts[] с пустым значением?
        // По логам видно, что сервер ожидает nfts[0]=значение
        // Для пустого массива — не передаем параметр nfts вообще
        
        return params.percentEncoded()
    }
}

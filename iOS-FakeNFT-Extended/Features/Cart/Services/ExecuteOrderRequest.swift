//
//  ExecuteOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 25.03.2026.
//

import Foundation

/// Запрос на выполнение заказа и очистку корзины
struct ExecuteOrderRequest: NetworkRequest {
    let nfts: [String]
    
    var httpMethod: HttpMethod { .post }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var body: Data? {
        let bodyString = nfts
            .map { nft in
                let encodedValue = nft.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? nft
                return "nfts=\(encodedValue)"
            }
            .joined(separator: "&")

        return bodyString.data(using: .utf8)
    }
}

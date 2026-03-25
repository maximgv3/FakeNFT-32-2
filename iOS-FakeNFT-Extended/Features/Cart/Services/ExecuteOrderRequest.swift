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
    
    var dto: Data? {
        // ✅ Формат nfts=id1,id2,id3
        let nftsString = nfts.joined(separator: ",")
        let params = ["nfts": nftsString]
        return params.percentEncoded()
    }
}

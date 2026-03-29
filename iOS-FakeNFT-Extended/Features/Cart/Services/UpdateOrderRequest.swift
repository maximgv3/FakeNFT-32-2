//
//  UpdateOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 14.03.2026.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    
    // MARK: - Properties
    
    let nfts: [String]
    
    // MARK: - NetworkRequest
    
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var body: Data? {
        if nfts.isEmpty {
            // ✅ Удаление последнего товара → пустое тело
            let params: [String: String] = [:]
            return params.percentEncoded()  // возвращает nil
        }
        
        // ✅ Есть товары → nfts=id1,id2
        let params: [String: String] = [
            "nfts": nfts.joined(separator: ",")
        ]
        return params.percentEncoded()
    }
}

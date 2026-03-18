//
//  UpdateOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 14.03.2026.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let nfts: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable? {
        nil
    }
}

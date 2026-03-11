//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

struct Order: Decodable {
    let nfts: [String]
    let id: String
}

//
//  CartServiceImpl.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

@MainActor
final class CartServiceImpl: CartService {
    private let networkClient: NetworkClient
    private let nftService: NftService
    
    init(
        networkClient: NetworkClient,
        nftService: NftService
    ) {
        self.networkClient = networkClient
        self.nftService = nftService
    }
    
    func loadCartItems() async throws -> [CartItem] {
        let order: Order = try await networkClient.send(request: OrderRequest())
        
        guard !order.nfts.isEmpty else {
            return []
        }
        
        var result: [CartItem] = []
        
        for nftId in order.nfts {
            let nft = try await nftService.loadNft(id: nftId)
            result.append(
                CartItem(
                    id: nft.id,
                    name: nft.name,
                    price: nft.price,
                    rating: nft.rating,
                    imageURL: nft.images.first
                )
            )
        }
        
        return result
    }
}

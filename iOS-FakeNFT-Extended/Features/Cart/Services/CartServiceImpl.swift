//
//  CartServiceImpl.swift
//  iOS-FakeNFT-Extended
//
//  Created by Рустам Ханахмедов on 11.03.2026.
//

import Foundation

actor CartServiceImpl: CartServiceProtocol {
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
        
        return try await withThrowingTaskGroup(of: (Int, CartItem).self) { group in
            for (index, nftId) in order.nfts.enumerated() {
                group.addTask { [nftService] in
                    let nft = try await nftService.loadNft(id: nftId)
                    return (index, Self.makeCartItem(from: nft))
                }
            }
            
            var indexedItems: [(Int, CartItem)] = []
            indexedItems.reserveCapacity(order.nfts.count)
            
            for try await indexedItem in group {
                indexedItems.append(indexedItem)
            }
            
            return indexedItems
                .sorted { $0.0 < $1.0 }
                .map(\.1)
        }
    }
    
    private static func makeCartItem(from nft: Nft) -> CartItem {
        CartItem(
            id: nft.id,
            name: nft.name,
            price: nft.price,
            rating: nft.rating,
            imageURL: nft.images.first
        )
    }
}

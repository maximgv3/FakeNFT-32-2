import Foundation

protocol NftService {
    func loadNft(id: String) async throws -> Nft
}


final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String) async throws -> Nft {
        if let nft = await storage.getNft(with: id) {
            return nft
        }

        let request = NFTRequest(id: id)
        let nft: Nft = try await networkClient.send(request: request)
        await storage.saveNft(nft)
        return nft
    }
}

struct MockNftService: NftService {
    func loadNft(id: String) async throws -> Nft {
        Nft(
            createdAt: "2026-03-26T00:00:00Z",
            name: "Mock NFT \(id.prefix(4))",
            images: [
                "https://i.pinimg.com/736x/e2/b3/ff/e2b3ff329c3a6ce26afcd1c53d9de30a.jpg"
            ],
            rating: 4,
            description: "Preview NFT",
            price: 10.0,
            author: "Preview Author",
            website: "https://example.com",
            id: id
        )
    }
}

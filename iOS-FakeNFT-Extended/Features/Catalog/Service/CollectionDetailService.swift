import Foundation

protocol CollectionDetailService: Sendable {
    func loadNfts(ids: [String]) async throws -> [Nft]
}

actor CollectionDetailServiceImpl: CollectionDetailService {

    // MARK: - Properties

    private let networkClient: NetworkClient

    // MARK: - Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public

    func loadNfts(ids: [String]) async throws -> [Nft] {
        try await withThrowingTaskGroup(of: Nft.self) { group in
            for id in ids {
                group.addTask {
                    let request = NFTRequest(id: id)
                    return try await self.networkClient.send(request: request)
                }
            }
            var nfts: [Nft] = []
            for try await nft in group {
                nfts.append(nft)
            }
            return nfts
        }
    }
}

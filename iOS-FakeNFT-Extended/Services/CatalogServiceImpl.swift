import Foundation

protocol CatalogService: Sendable {
    func loadCollections() async throws -> [NftCollection]
}

actor CatalogServiceImpl: CatalogService {

    // MARK: - Properties

    private let networkClient: NetworkClient

    // MARK: - Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public

    func loadCollections() async throws -> [NftCollection] {
        let request = CatalogCollectionsRequest()
        let collections: [NftCollection] = try await networkClient.send(request: request)
        return collections
    }
}

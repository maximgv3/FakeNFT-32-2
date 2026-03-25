import Foundation

@Observable
@MainActor
final class CollectionDetailViewModel {

    // MARK: - Properties

    var nfts: [Nft] = []
    var isLoading = false
    var showError = false

    private let collection: NftCollection
    private let collectionDetailService: CollectionDetailService

    // MARK: - Init

    init(collection: NftCollection, collectionDetailService: CollectionDetailService) {
        self.collection = collection
        self.collectionDetailService = collectionDetailService
    }

    // MARK: - Public

    func loadNfts() async {
        isLoading = true
        do {
            nfts = try await collectionDetailService.loadNfts(ids: collection.nfts)
        } catch {
            showError = true
        }
        isLoading = false
    }
}

import Foundation
import Observation

@Observable @MainActor
final class FavoriteNFTsViewModel {
    var nfts: [Nft] = []
    private(set) var isLoading = false
    private(set) var isFavoriteActionInProgress = false
    private(set) var errorMessage: String?

    private let nftService: NftService
    private let onRemoveFromFavorites: (String) async -> Void

    init(
        nftService: NftService,
        onRemoveFromFavorites: @escaping (String) async -> Void
    ) {
        self.nftService = nftService
        self.onRemoveFromFavorites = onRemoveFromFavorites
    }

    func loadNFTs(ids: [String]) async {
        guard !ids.isEmpty else {
            nfts = []
            errorMessage = nil
            return
        }
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        var loadedNfts: [Nft] = []

        do {
            try await withThrowingTaskGroup(of: Nft.self) { group in
                for id in ids {
                    group.addTask {
                        try await self.nftService.loadNft(id: id)
                    }
                }
                for try await nft in group {
                    loadedNfts.append(nft)
                }
            }
            nfts = loadedNfts
        } catch {
            errorMessage = ErrorMessageMapper.message(from: error)
        }
    }

    func removeFavorite(_ nftId: String) async {
        guard !isFavoriteActionInProgress else { return }

        isFavoriteActionInProgress = true
        defer { isFavoriteActionInProgress = false }

        await onRemoveFromFavorites(nftId)
    }
}

import Foundation
import Observation

@Observable @MainActor
final class FavoriteNFTsViewModel {
    var nfts: [Nft] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private let nftService: NftService
    init(nftService: NftService) {
        self.nftService = nftService
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
            errorMessage = error.localizedDescription
        }
    }

}

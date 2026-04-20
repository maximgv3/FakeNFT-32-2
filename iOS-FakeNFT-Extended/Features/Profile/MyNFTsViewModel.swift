import Foundation
import Observation

@Observable @MainActor
final class MyNFTsViewModel {
    enum SortOption: String {
        case price
        case rating
        case name
    }

    private let nftService: NftService
    private let nftIds: [String]
    private let onToggleFavorite: (String) async -> Void
    private let userDefaultsService: UserDefaultsService

    var isLoading = false
    var isFavoriteActionInProgress = false
    var errorMessage: String?
    var favoriteIds: [String]
    var nfts: [Nft] = []
    var selectedSort: SortOption

    var isEmpty: Bool {
        nfts.isEmpty
    }

    init(
        nftService: NftService,
        nftIds: [String],
        favoriteIds: [String],
        onToggleFavorite: @escaping (String) async -> Void,
        userDefaultsService: UserDefaultsService = .shared
    ) {
        self.nftService = nftService
        self.nftIds = nftIds
        self.favoriteIds = favoriteIds
        self.onToggleFavorite = onToggleFavorite
        self.userDefaultsService = userDefaultsService

        if let savedValue = userDefaultsService.myNFTsSortOption,
           let savedSort = SortOption(rawValue: savedValue) {
            selectedSort = savedSort
        } else {
            selectedSort = .rating
        }
    }

    var sortedNfts: [Nft] {
        switch selectedSort {
        case .price:
            nfts.sorted { $0.price < $1.price }
        case .rating:
            nfts.sorted { $0.rating > $1.rating }
        case .name:
            nfts.sorted { $0.name < $1.name }
        }
    }

    func loadNFTs() async {
        guard nfts.isEmpty else { return }
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        var loadedNfts: [Nft] = []
        do {
            try await withThrowingTaskGroup(of: Nft.self) { group in
                for id in nftIds {
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

    func setSort(_ option: SortOption) {
        selectedSort = option
        userDefaultsService.myNFTsSortOption = option.rawValue
    }

    func syncFavoriteIds(_ newValue: [String]) {
        favoriteIds = newValue
    }

    func isFavorite(_ nftId: String) -> Bool {
        favoriteIds.contains(nftId)
    }

    func toggleFavorite(_ nftId: String) async {
        guard !isFavoriteActionInProgress else { return }

        isFavoriteActionInProgress = true
        defer { isFavoriteActionInProgress = false }

        await onToggleFavorite(nftId)
    }
}

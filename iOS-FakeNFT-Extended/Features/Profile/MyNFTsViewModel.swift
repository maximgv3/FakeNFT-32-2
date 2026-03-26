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
    var isLoading = false
    var errorMessage: String?

    private let userDefaultsService: UserDefaultsService

    var nfts: [Nft] = []
    var selectedSort: SortOption

    var isEmpty: Bool {
        nfts.isEmpty
    }

    init(
        nftService: NftService,
        nftIds: [String],
        userDefaultsService: UserDefaultsService = .shared
    ) {
        self.nftService = nftService
        self.nftIds = nftIds
        self.userDefaultsService = userDefaultsService

        if let savedValue = userDefaultsService.myNFTsSortOption,
            let savedSort = SortOption(rawValue: savedValue)
        {
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
}

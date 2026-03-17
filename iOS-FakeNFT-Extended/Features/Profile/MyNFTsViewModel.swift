import Foundation
import Observation

@Observable
final class MyNFTsViewModel {
    enum SortOption {
        case price
        case rating
        case name
    }

    var nfts: [Nft] = Nft.mocks
    var selectedSort: SortOption = .price

    var isEmpty: Bool {
        nfts.isEmpty
    }

    var sortedNfts: [Nft] {
        switch selectedSort {
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted { $0.name < $1.name }
        }
    }

    func setSort(_ option: SortOption) {
        selectedSort = option
    }
}

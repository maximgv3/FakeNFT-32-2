import Foundation
import Observation

@Observable
final class MyNFTsViewModel {
    enum SortOption: String {
        case price
        case rating
        case name
    }

    private let sortOptionKey = "myNFTs.sortOption"

    var nfts: [Nft] = Nft.mocks
    var selectedSort: SortOption

    var isEmpty: Bool {
        nfts.isEmpty
    }

    init() {
        if let savedValue = UserDefaults.standard.string(forKey: sortOptionKey),
           let savedSort = SortOption(rawValue: savedValue) {
            selectedSort = savedSort
        } else {
            selectedSort = .price
        }
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
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
}

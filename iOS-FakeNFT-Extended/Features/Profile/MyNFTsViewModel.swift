import Foundation
import Observation

@Observable
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
    
    
    private let sortOptionKey = "myNFTs.sortOption"

    var nfts: [Nft] = []
    var selectedSort: SortOption

    var isEmpty: Bool {
        nfts.isEmpty
    }

    init(nftService: NftService, nftIds: [String]) {
        self.nftService = nftService
        self.nftIds = nftIds
        if let savedValue = UserDefaults.standard.string(forKey: sortOptionKey),
           let savedSort = SortOption(rawValue: savedValue) {
            selectedSort = savedSort
        } else {
            selectedSort = .rating
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

    func loadNFTs() async {
        guard nfts.isEmpty else { return }
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        var loadedNfts: [Nft] = []
        do {
            for id in nftIds {
                let nft = try await nftService.loadNft(id: id)
                loadedNfts.append(nft)
            }
            nfts = loadedNfts
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func setSort(_ option: SortOption) {
        selectedSort = option
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
}

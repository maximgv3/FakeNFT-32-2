import Foundation

@Observable
@MainActor
final class CatalogViewModel {

    // MARK: - Properties

    var collections: [NftCollection] = []
    var isLoading = false
    var showError = false
    var isSortSheetPresented = false

    var selectedSortOption: SortOption? {
        didSet {
            saveSortOption(selectedSortOption)
        }
    }

    var sortedCollections: [NftCollection] {
        switch selectedSortOption {
        case .byName:
            return collections.sorted { $0.name < $1.name }
        case .byNFTCount:
            return collections.sorted { $0.nftCount > $1.nftCount }
        case nil:
            return collections
        }
    }

    private let catalogService: CatalogService

    // MARK: - Init

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
        self.selectedSortOption = loadSortOption()
    }

    // MARK: - Public

    func loadCollections() async {
        isLoading = true
        do {
            collections = try await catalogService.loadCollections()
        } catch {
            showError = true
        }
        isLoading = false
    }

    // MARK: - Private

    private func saveSortOption(_ option: SortOption?) {
        switch option {
        case .byName:
            UserDefaults.standard.set("byName", forKey: Constants.sortOptionKey)
        case .byNFTCount:
            UserDefaults.standard.set("byNFTCount", forKey: Constants.sortOptionKey)
        case nil:
            UserDefaults.standard.removeObject(forKey: Constants.sortOptionKey)
        }
    }

    private func loadSortOption() -> SortOption? {
        switch UserDefaults.standard.string(forKey: Constants.sortOptionKey) {
        case "byName": return .byName
        case "byNFTCount": return .byNFTCount
        default: return nil
        }
    }
}

// MARK: - Constants

private extension CatalogViewModel {
    enum Constants {
        static let sortOptionKey = "catalogSortOption"
    }
}

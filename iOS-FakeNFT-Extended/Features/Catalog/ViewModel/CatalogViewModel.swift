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
            userDefaultsService.sortOption = selectedSortOption
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
    private let userDefaultsService: UserDefaultsService

    // MARK: - Init

    init(catalogService: CatalogService, userDefaultsService: UserDefaultsService = .shared) {
        self.catalogService = catalogService
        self.userDefaultsService = userDefaultsService
        self.selectedSortOption = userDefaultsService.sortOption
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
}

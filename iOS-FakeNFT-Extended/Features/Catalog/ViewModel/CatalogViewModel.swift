import Foundation

@Observable
@MainActor
final class CatalogViewModel {

    // MARK: - Properties

    var collections: [NftCollection] = []
    var isLoading = false
    var showError = false
    var isSortSheetPresented = false

    private let catalogService: CatalogService

    // MARK: - Init

    init(catalogService: CatalogService) {
        self.catalogService = catalogService
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

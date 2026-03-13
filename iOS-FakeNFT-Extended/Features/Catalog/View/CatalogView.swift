import SwiftUI

struct CatalogView: View {

    // MARK: - Properties

    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var viewModel: CatalogViewModel?
    @State private var showingSortSheet = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                if let viewModel, viewModel.isLoading {
                    ProgressView()
                } else {
                    collectionList
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                sortButton
                            }
                        }
                }
            }
            .task {
                if viewModel == nil {
                    viewModel = CatalogViewModel(
                        catalogService: servicesAssembly.catalogService
                    )
                }
                await viewModel?.loadCollections()
            }
            .alert(
                NSLocalizedString("Error.title", comment: ""),
                isPresented: Binding(
                    get: { viewModel?.showError ?? false },
                    set: { viewModel?.showError = $0 }
                )
            ) {
                Button(NSLocalizedString("Error.repeat", comment: "")) {
                    Task {
                        await viewModel?.loadCollections()
                    }
                }
            } message: {
                Text(NSLocalizedString("Error.network", comment: ""))
            }
        }
    }

    // MARK: - Subviews

    private var collectionList: some View {
        ScrollView {
            LazyVStack(spacing: Constants.cellSpacing) {
                if let viewModel {
                    ForEach(viewModel.collections, id: \.id) { collection in
                        NavigationLink(destination: CollectionDetailView(collection: collection)) {
                            CatalogCollectionCell(
                                name: collection.name,
                                nftCount: collection.nftCount,
                                coverURL: makeCoverURL(collection.cover)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, Constants.topPadding)
        }
    }

    private var sortButton: some View {
        Button {
            showingSortSheet = true
        } label: {
            Image(.sort)
                .resizable()
                .frame(
                    width: Constants.sortButtonSize,
                    height: Constants.sortButtonSize
                )
                .foregroundStyle(Color.ypBlack)
        }
    }

    // MARK: - Private

    private func makeCoverURL(_ urlString: String) -> URL? {
        let encoded = urlString.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        return URL(string: encoded ?? urlString)
    }
}

// MARK: - Constants

private extension CatalogView {
    enum Constants {
        static let sortButtonSize: CGFloat = 42
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 20
        static let cellSpacing: CGFloat = 21
    }
}

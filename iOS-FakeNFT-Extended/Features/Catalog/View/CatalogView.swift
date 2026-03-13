import SwiftUI

struct CatalogView: View {

    // MARK: - Properties

    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var viewModel: CatalogViewModel?
    @State private var showingSortSheet = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Constants.cellSpacing) {
                    if let viewModel {
                        ForEach(viewModel.collections, id: \.id) { collection in
                            CatalogCollectionCell(
                                name: collection.name,
                                nftCount: collection.nftCount,
                                coverURL: URL(string: collection.cover)
                            )
                        }
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.top, Constants.topPadding)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton
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
        }
    }

    // MARK: - Subviews

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



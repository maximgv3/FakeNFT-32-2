import SwiftUI

struct CatalogView: View {

    // MARK: - Properties

    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var viewModel: CatalogViewModel?

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
            .fullScreenCover(isPresented: Binding(
                get: { viewModel?.isSortSheetPresented ?? false },
                set: { viewModel?.isSortSheetPresented = $0 }
            )) {
                ZStack(alignment: .bottom) {
                    Color.black
                        .opacity(Constants.dimOpacity)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel?.isSortSheetPresented = false
                        }

                    CatalogSortView(
                        isPresented: Binding(
                            get: { viewModel?.isSortSheetPresented ?? false },
                            set: { viewModel?.isSortSheetPresented = $0 }
                        ),
                        selectedSortOption: Binding(
                            get: { viewModel?.selectedSortOption },
                            set: { viewModel?.selectedSortOption = $0 }
                        )
                    )
                }
                .background(ClearBackground())
            }
        }
    }

    // MARK: - Subviews

    private var collectionList: some View {
        ScrollView {
            LazyVStack(spacing: Constants.cellSpacing) {
                if let viewModel {
                    ForEach(viewModel.sortedCollections, id: \.id) { collection in
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
            viewModel?.isSortSheetPresented = true
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
        static let dimOpacity: Double = 0.5
    }
}

// MARK: - ClearBackground

private struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

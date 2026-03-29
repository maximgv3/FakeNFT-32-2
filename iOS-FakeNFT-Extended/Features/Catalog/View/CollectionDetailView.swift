import SwiftUI
import Kingfisher

struct CollectionDetailView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var viewModel: CollectionDetailViewModel?
    @State private var isAuthorWebViewPresented = false
    let collection: NftCollection

    // MARK: - Body

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    coverSection
                    infoSection
                    if let viewModel {
                        nftSection(viewModel: viewModel)
                    }
                }
            }

            if viewModel?.isLoading == true {
                ProgressView()
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .overlay(alignment: .topLeading) {
            backButton
                .padding(.leading, Constants.backButtonLeadingPadding)
                .padding(.top, Constants.backButtonTopPadding)
        }
        .navigationDestination(isPresented: $isAuthorWebViewPresented) {
            if let url = authorURL {
                WebView(url: url)
            }
        }
        .task {
            if viewModel == nil {
                viewModel = CollectionDetailViewModel(
                    collection: collection,
                    collectionDetailService: servicesAssembly.collectionDetailService
                )
            }
            await viewModel?.loadNfts()
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
                    await viewModel?.loadNfts()
                }
            }
        } message: {
            Text(NSLocalizedString("Error.network", comment: ""))
        }
    }

    // MARK: - Subviews

    private var coverSection: some View {
        KFImage(coverURL)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: Constants.coverHeight)
            .clipped()
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: Constants.coverCornerRadius,
                    bottomTrailingRadius: Constants.coverCornerRadius,
                    topTrailingRadius: 0
                )
            )
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(collection.name.capitalizedFirst)
                .font(.system(size: 22, weight: .bold))
                .kerning(0.35)
                .foregroundStyle(Color.ypBlack)
                .frame(minHeight: Constants.titleLineHeight)

            authorLine
                .frame(minHeight: Constants.authorLineHeight)
                .padding(.top, Constants.authorTopPadding)

            Text(collection.description.capitalizedFirst)
                .font(.system(size: 13))
                .kerning(-0.08)
                .foregroundStyle(Color.ypBlack)
                .padding(.top, Constants.descriptionTopPadding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, Constants.infoTopPadding)
    }

    private func nftSection(viewModel: CollectionDetailViewModel) -> some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible()),
                count: 3
            ),
            spacing: Constants.gridRowSpacing
        ) {
            ForEach(Array(viewModel.nfts.enumerated()), id: \.offset) { _, nft in
                NftCollectionCell(nft: nft)
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, Constants.nftTopPadding)
        .padding(.bottom, Constants.nftBottomPadding)
    }

    private var authorLine: some View {
        Button {
            isAuthorWebViewPresented = true
        } label: {
            HStack(spacing: 0) {
                Text("Автор коллекции: ")
                    .font(.system(size: 13))
                    .kerning(-0.08)
                    .foregroundStyle(Color.ypBlack)
                Text(collection.author)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.ypUBlue)
            }
        }
        .buttonStyle(.plain)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.chevronLeft)
                .frame(
                    width: Constants.backButtonSize,
                    height: Constants.backButtonSize
                )
                .foregroundStyle(Color.ypBlack)
        }
    }

    // MARK: - Private

    private var coverURL: URL? {
        let encoded = collection.cover.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        return URL(string: encoded ?? collection.cover)
    }

    private var authorURL: URL? {
        return URL(string: "https://practicum.yandex.ru")
    }
}

// MARK: - Constants

private extension CollectionDetailView {
    enum Constants {
        static let coverHeight: CGFloat = 310
        static let coverCornerRadius: CGFloat = 12
        static let backButtonSize: CGFloat = 24
        static let backButtonLeadingPadding: CGFloat = 9
        static let backButtonTopPadding: CGFloat = 11
        static let horizontalPadding: CGFloat = 16
        static let infoTopPadding: CGFloat = 16
        static let titleLineHeight: CGFloat = 28
        static let authorLineHeight: CGFloat = 20
        static let authorTopPadding: CGFloat = 8
        static let descriptionTopPadding: CGFloat = 5
        static let gridRowSpacing: CGFloat = 8
        static let nftTopPadding: CGFloat = 24
        static let nftBottomPadding: CGFloat = 24
    }
}

// MARK: - String Extension

private extension String {
    var capitalizedFirst: String {
        guard let first else { return self }
        return first.uppercased() + dropFirst()
    }
}

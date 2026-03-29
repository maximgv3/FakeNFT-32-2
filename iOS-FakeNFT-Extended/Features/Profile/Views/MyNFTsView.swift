import SwiftUI

struct MyNFTsView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: MyNFTsViewModel
    @State private var isSortDialogPresented = false
    private let favoriteIds: [String]
    
    init(nftIds: [String], favoriteIds: [String], nftService: NftService, onToggleFavorite: @escaping (String) async -> Void) {
        _viewModel = State(initialValue: MyNFTsViewModel(
            nftService: nftService,
            nftIds: nftIds,
            favoriteIds: favoriteIds,
            onToggleFavorite: onToggleFavorite
        ))
        self.favoriteIds = favoriteIds
    }
    
    var body: some View {
        ZStack {
            backgroundView
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.errorMessage,
                      !errorMessage.isEmpty {
                emptyStateView(message: errorMessage)
            } else if viewModel.isEmpty {
                emptyStateView(message: "У Вас ещё нет NFT")
            } else {
                nftListView
            }

            if viewModel.isFavoriteActionInProgress {
                progressOverlay
            }
        }
        .navigationTitle("Мои NFT")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.ypBlack)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSortDialogPresented = true
                } label: {
                    Image(.sort)
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(.ypBlack)
                }
            }
        }
        .confirmationDialog("Сортировка", isPresented: $isSortDialogPresented, titleVisibility: .visible) {
            Button("По цене") {
                viewModel.setSort(.price)
            }
            Button("По рейтингу") {
                viewModel.setSort(.rating)
            }
            Button("По названию") {
                viewModel.setSort(.name)
            }
            Button("Закрыть", role: .cancel) {
            }
        }
        .task {
            await viewModel.loadNFTs()
        }
        .onChange(of: favoriteIds) { _, newValue in
            viewModel.syncFavoriteIds(newValue)
        }
        .allowsHitTesting(!viewModel.isFavoriteActionInProgress)
    }

    private var backgroundView: some View {
        Color.ypWhite
            .ignoresSafeArea()
    }

    private var loadingView: some View {
        ProgressView()
            .tint(.ypBlack)
    }

    private var progressOverlay: some View {
        ZStack {
            Color.black.opacity(0.08)
                .ignoresSafeArea()

            ProgressView()
                .tint(.ypBlack)
                .padding(24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private func emptyStateView(message: String) -> some View {
        Text(message)
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(.ypBlack)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
    }

    private var nftListView: some View {
        List(viewModel.sortedNfts) { nft in
            nftRow(for: nft)
                .listRowInsets(
                    EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 39)
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .padding(.top, 20)
    }

    private func nftRow(for nft: Nft) -> some View {
        HStack(spacing: 20) {
            ZStack(alignment: .topTrailing) {
                nftImageView(for: nft)
                Button {
                    Task {
                        await viewModel.toggleFavorite(nft.id)
                    }
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(viewModel.isFavorite(nft.id) ? .ypURed : .ypUWhite)
                        .padding(10)
                }
            }
            nftInfoView(for: nft)
        }
    }

    private func nftImageView(for nft: Nft) -> some View {
        Group {
            if let imageString = nft.images.first,
               let imageURL = URL(string: imageString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.ypLightGrey
                            ProgressView()
                                .tint(.ypBlack)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        nftImagePlaceholder
                    @unknown default:
                        nftImagePlaceholder
                    }
                }
            } else {
                nftImagePlaceholder
            }
        }
        .frame(width: 108, height: 108)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var nftImagePlaceholder: some View {
        Color.ypLightGrey
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.ypBlack)
            }
    }

    private func nftInfoView(for nft: Nft) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                RatingStars(rating: nft.rating)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("от")
                        .font(.system(size: 15, weight: .regular))
                    Text(nft.author)
                        .font(.system(size: 13, weight: .regular))
                }
            }
            Spacer()
            VStack(alignment: .leading, spacing: 2) {
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                Text(String(nft.price) + " ETH")
                    .font(.system(size: 17, weight: .bold))
            }
        }
    }

}

#Preview {
    @Previewable @State var nftIds = [
        "b3907b86-37c4-4e15-95bc-7f8147a9a660",
        "9810d484-c3fc-49e8-bc73-f5e602c36b40",
        "7773e33c-ec15-4230-a102-92426a3a6d5a",
    ]
    
    @Previewable @State var favorites = [
        "b3907b86-37c4-4e15-95bc-7f8147a9a660"
    ]
    
    NavigationStack {
        MyNFTsView(nftIds: nftIds, favoriteIds: favorites, nftService: MockNftService(), onToggleFavorite: { _ in })
    }
}

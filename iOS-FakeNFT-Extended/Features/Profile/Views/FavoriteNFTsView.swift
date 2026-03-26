import SwiftUI

struct FavoriteNFTsView: View {
    @State private var viewModel: FavoriteNFTsViewModel
    @Binding var nftIds: [String]
    let onRemoveFromFavorites: (String) async -> Void

    init(
        nftIds: Binding<[String]>,
        nftService: NftService,
        onRemoveFromFavorites: @escaping (String) async -> Void
    ) {
        _viewModel = State(
            initialValue: FavoriteNFTsViewModel(nftService: nftService)
        )
        _nftIds = nftIds
        self.onRemoveFromFavorites = onRemoveFromFavorites
    }

    var body: some View {
        ZStack {
            Color.ypWhite.ignoresSafeArea()
                grid()
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
        }
        .navigationTitle("Избранные NFT")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadNFTs(ids: nftIds)
        }
        .onChange(of: nftIds) { _, newValue in
            Task {
                await viewModel.loadNFTs(ids: newValue)
            }
        }
    }

    private func removeNftLike(forId id: String) {
        Task {
            await onRemoveFromFavorites(id)
        }
    }

    @ViewBuilder
    private func grid() -> some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(.ypBlack)
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
        } else if nftIds.isEmpty {
            Text("У Вас ещё нет избранных NFT")
                .font(.system(size: 17, weight: .bold))
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.nfts, id: \.id) { nft in
                        nftCard(nft: nft)
                    }
                }
            }

        }
    }

    private func nftCard(nft: Nft) -> some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                nftImageView(for: nft)
                Button {
                    removeNftLike(forId: nft.id)
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundStyle(.ypURed)
                        .padding(4)
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(nft.name)
                    .lineLimit(1)
                    .font(.system(size: 17, weight: .bold))
                RatingStars(rating: nft.rating)
                Text(String(nft.price) + " ETH")
                    .font(.system(size: 15, weight: .regular))
                    .padding(.top, 4)
            }
        }
    }
    private let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7),
    ]

    private func nftImageView(for nft: Nft) -> some View {
        Group {
            if let imageString = nft.images.first,
                let imageURL = URL(string: imageString)
            {
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
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var nftImagePlaceholder: some View {
        Color.ypLightGrey
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.ypBlack)
            }
    }

}

struct MockNftService: NftService {
    func loadNft(id: String) async throws -> Nft {
        Nft(
            createdAt: "2026-03-26T00:00:00Z",
            name: "Mock NFT \(id.prefix(4))",
            images: [
                "https://i.pinimg.com/736x/e2/b3/ff/e2b3ff329c3a6ce26afcd1c53d9de30a.jpg"
            ],
            rating: 4,
            description: "Preview NFT",
            price: 10.0,
            author: "Preview Author",
            website: "https://example.com",
            id: id
        )
    }
}

#Preview {
    @Previewable @State var nftIds = [
        "b3907b86-37c4-4e15-95bc-7f8147a9a660",
        "9810d484-c3fc-49e8-bc73-f5e602c36b40",
        "7773e33c-ec15-4230-a102-92426a3a6d5a",
    ]

    NavigationStack {
        FavoriteNFTsView(
            nftIds: $nftIds,
            nftService: MockNftService(),
            onRemoveFromFavorites: { _ in }
        )
    }
}

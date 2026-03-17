import SwiftUI

struct MyNFTsView: View {

    private var viewModel = MyNFTsViewModel()
    
    @State private var isSortDialogPresented = false
    
    var body: some View {
        ZStack {
            backgroundView
            if viewModel.isEmpty {
                emptyNftsText
            } else {
                nftListView
            }
        }
        .navigationTitle("Мои NFT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSortDialogPresented = true
                } label: {
                    Image("sort")
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
    }

    private var backgroundView: some View {
        Color.ypWhite
            .ignoresSafeArea()
    }

    private var emptyNftsText: some View {
        Text("У Вас ещё нет NFT")
            .font(.system(size: 17, weight: .bold))
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
            nftImageView(for: nft)
            nftInfoView(for: nft)
        }
    }

    private func nftImageView(for nft: Nft) -> some View {
        Image(nft.images.first!)
            .frame(width: 108, height: 108)
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
    NavigationStack {
        MyNFTsView()
    }
}

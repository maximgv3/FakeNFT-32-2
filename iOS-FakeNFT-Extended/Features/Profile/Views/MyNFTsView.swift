import SwiftUI

struct MyNFTsView: View {

    var nfts = Nft.mocks

    var body: some View {
        ZStack {
            backgroundView
            nftListView
        }
    }

    private var backgroundView: some View {
        Color.ypWhite
    }

    private var nftListView: some View {
        List(nfts) { nft in
            nftRow(for: nft)
                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 39))
                .listRowSeparator(.hidden)
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
    MyNFTsView()
}

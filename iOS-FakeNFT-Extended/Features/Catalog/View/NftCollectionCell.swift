import SwiftUI
import Kingfisher

struct NftCollectionCell: View {

    // MARK: - Properties

    let nft: Nft
    let isLiked: Bool
    let isInCart: Bool
    let onLikeTapped: () async -> Void
    let onCartTapped: () async -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            ratingSection
                .padding(.top, Constants.ratingTopPadding)
            infoSection
                .padding(.top, Constants.infoTopPadding)
                .padding(.bottom, Constants.bottomPadding)
            Spacer()
        }
    }

    // MARK: - Subviews

    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            KFImage(nftImageURL)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))

            Button {
                Task { await onLikeTapped() }
            } label: {
                Image(isLiked ? .active : .noActive)
                    .renderingMode(.original)
                    .frame(width: Constants.heartButtonSize, height: Constants.heartButtonSize)
            }
        }
    }

    private var ratingSection: some View {
        HStack(spacing: Constants.starSpacing) {
            ForEach(1...5, id: \.self) { index in
                Image(.star)
                    .resizable()
                    .frame(width: Constants.starSize, height: Constants.starSize)
                    .foregroundStyle(index <= nft.rating ? Color.yellow : Color.ypLightGrey)
            }
        }
    }

    private var infoSection: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: Constants.priceTopPadding) {
                Text(nft.name.capitalizedFirst)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.ypBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("\(String(format: "%.2f", nft.price)) ETH")
                    .font(.system(size: 10, weight: .medium))
                    .kerning(-0.24)
                    .foregroundStyle(Color.ypBlack)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                Task { await onCartTapped() }
            } label: {
                Image(isInCart ? .cartCross : .cart)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: Constants.cartSize, height: Constants.cartSize)
            }
        }
    }

    // MARK: - Private

    private var nftImageURL: URL? {
        nft.images.first.flatMap { URL(string: $0) }
    }
}

// MARK: - Constants

private extension NftCollectionCell {
    enum Constants {
        static let imageCornerRadius: CGFloat = 12
        static let heartButtonSize: CGFloat = 40
        static let ratingTopPadding: CGFloat = 8
        static let starSize: CGFloat = 12
        static let starSpacing: CGFloat = 2
        static let infoTopPadding: CGFloat = 5
        static let priceTopPadding: CGFloat = 4
        static let cartSize: CGFloat = 40
        static let bottomPadding: CGFloat = 8
    }
}

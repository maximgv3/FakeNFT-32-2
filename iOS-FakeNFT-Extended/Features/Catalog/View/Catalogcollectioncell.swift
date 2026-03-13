import SwiftUI

struct CatalogCollectionCell: View {

    // MARK: - Properties

    let name: String
    let nftCount: Int
    let coverURL: URL?

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.imageToTextSpacing) {
            coverImage
            titleLabel
        }
    }

    // MARK: - Subviews

    private var coverImage: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(Color.ypLightGrey)
            .frame(height: Constants.imageHeight)
    }

    private var titleLabel: some View {
        Text("\(name) (\(nftCount))")
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(Color.ypBlack)
    }
}

// MARK: - Constants

private extension CatalogCollectionCell {
    enum Constants {
        static let imageHeight: CGFloat = 140
        static let cornerRadius: CGFloat = 12
        static let imageToTextSpacing: CGFloat = 4
    }
}

// MARK: - Preview

#Preview {
    CatalogCollectionCell(
        name: "Peach",
        nftCount: 11,
        coverURL: nil
    )
    .padding(.horizontal, 16)
}

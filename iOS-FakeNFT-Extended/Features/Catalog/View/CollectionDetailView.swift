import SwiftUI
import Kingfisher

struct CollectionDetailView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    let collection: NftCollection

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                coverSection
                infoSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading) {
            backButton
                .padding(.leading, Constants.backButtonLeadingPadding)
                .padding(.top, Constants.backButtonTopPadding)
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
                .frame(minHeight: Constants.titleLineHeight, alignment: .center)

            authorLine
                .frame(minHeight: Constants.authorLineHeight, alignment: .center)
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

    private var authorLine: some View {
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
    }
}

// MARK: - String Extension

private extension String {
    var capitalizedFirst: String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst()
    }
}

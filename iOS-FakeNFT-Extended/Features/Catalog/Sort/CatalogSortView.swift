import SwiftUI

struct CatalogSortView: View {

    // MARK: - Properties

    @Binding var isPresented: Bool
    @Binding var selectedSortOption: SortOption?

    // MARK: - Body

    var body: some View {
        VStack(spacing: Constants.groupSpacing) {
            optionsGroup
            closeButton
        }
        .padding(.horizontal, Constants.horizontalPadding)
    }

    // MARK: - Subviews

    private var optionsGroup: some View {
        VStack(spacing: 0) {
            Text("Сортировка")
                .font(.system(size: 13))
                .foregroundStyle(Color(.secondaryLabel))
                .frame(maxWidth: .infinity)
                .frame(height: Constants.headerHeight)

            Divider()

            sortButton(option: .byName)

            Divider()

            sortButton(option: .byNFTCount)
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    private var closeButton: some View {
        Button {
            isPresented = false
        } label: {
            Text("Закрыть")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.ypUBlue)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.buttonHeight)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    private func sortButton(option: SortOption) -> some View {
        Button {
            selectedSortOption = option
            isPresented = false
        } label: {
            ZStack {
                Text(option.title)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.ypUBlue)
                    .frame(maxWidth: .infinity)

                if selectedSortOption == option {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.ypUBlue)
                    }
                    .padding(.horizontal, Constants.buttonHorizontalPadding)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.buttonHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension CatalogSortView {
    enum Constants {
        static let headerHeight: CGFloat = 42
        static let buttonHeight: CGFloat = 61
        static let cornerRadius: CGFloat = 13
        static let horizontalPadding: CGFloat = 8
        static let groupSpacing: CGFloat = 8
        static let buttonHorizontalPadding: CGFloat = 16
    }
}

import SwiftUI

struct CatalogView: View {
    
    // MARK: - State
    
    @State private var showingSortSheet = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Constants.cellSpacing) {
                    ForEach(0..<5) { index in
                        CatalogCollectionCell(
                            name: "Collection \(index)",
                            nftCount: index * 3,
                            coverURL: nil
                        )
                    }
                }
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.top, Constants.topPadding)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var sortButton: some View {
        Button {
            showingSortSheet = true
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
}

// MARK: - Constants

private extension CatalogView {
    enum Constants {
        static let sortButtonSize: CGFloat = 42
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 20
        static let cellSpacing: CGFloat = 21
    }
}

// MARK: - Preview

#Preview {
    CatalogView()
}

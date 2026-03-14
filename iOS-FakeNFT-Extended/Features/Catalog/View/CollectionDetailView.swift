import SwiftUI

struct CollectionDetailView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    let collection: NftCollection

    // MARK: - Body

    var body: some View {
        Text(collection.name.capitalized)
            .font(Font(UIFont.headline3))
            .foregroundStyle(Color.ypBlack)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }
    }

    // MARK: - Subviews

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.chevronLeft)
                .foregroundStyle(Color.ypBlack)
        }
    }
}

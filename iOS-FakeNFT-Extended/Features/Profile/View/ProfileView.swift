import SwiftUI

struct ProfileView: View {

    private let profileName = "Name Surname"
    private let profileDescription = "Description description description description description description description description description description description description description description description description description description description"
    private let profileWebsiteText = "Link to website"
    private let myNFTCount = 112
    private let favoriteNFTCount = 11
    private let profileAvatarImageName = "profile_avatar_mock"

    var body: some View {
        NavigationStack {
            ZStack {
                Color.ypWhite
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: .zero) {
                    profileHeader
                    nftMenu
                        .padding(.top, 40)
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            editTapped()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.ypBlack)
                        }
                    }
                }
            }
        }
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(alignment: .center) {
                Image(profileAvatarImageName)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                Text(profileName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.ypBlack)
                    .padding(.leading, 16)
            }
            Text(profileDescription)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.ypBlack)
                .padding(.top, 20)
                .padding(.trailing, 2)
            Text(profileWebsiteText)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.ypUBlue)
                .padding(.top, 8)
        }
    }

    private var nftMenu: some View {
        VStack(spacing: .zero) {
            nftMenuRow(title: "Мои NFT", count: myNFTCount, action: myNFTsTapped)
            nftMenuRow(title: "Избранные NFT", count: favoriteNFTCount, action: favoriteNFTsTapped)
        }
    }

    private func nftMenuRow(
        title: String,
        count: Int?,
        action: @escaping () -> Void
    ) -> some View {
        let titleWithCount = count.map { "\(title)  (\($0))" } ?? title

        return Button(action: action) {
            HStack(spacing: .zero) {
                Text(titleWithCount)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.ypBlack)
                    .padding(.vertical, 16)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.ypBlack)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func editTapped() {
        print("Edit tapped")
    }

    private func myNFTsTapped() {
        print("My NFTs tapped")
    }

    private func favoriteNFTsTapped() {
        print("Favorite NFTs tapped")
    }
}

#Preview {
    ProfileView()
}

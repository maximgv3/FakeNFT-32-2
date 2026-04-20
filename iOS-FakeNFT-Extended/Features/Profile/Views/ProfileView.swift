import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var viewModel: ProfileViewModel?
    
    enum Route: Hashable {
        case edit
        case myNFTs
        case favoriteNFTs
        case webView
    }

    @Binding private var path: [Route]

    init(path: Binding<[Route]>) {
        _path = path
    }

    var body: some View {
        ZStack {
            Color.ypWhite
                .ignoresSafeArea()

            if viewModel?.isLoading == true {
                loadingView
            } else if let errorMessage = viewModel?.errorMessage,
                      !errorMessage.isEmpty {
                errorView(message: errorMessage)
            } else {
                contentView
            }
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .edit:
                if let profile = viewModel?.profile {
                    ProfileEditView(
                        profile: profile,
                        profileService: servicesAssembly.profileService
                    ) { updatedProfile in
                        viewModel?.profile = updatedProfile
                    }
                } else {
                    EmptyView()
                }
            case .myNFTs:
                MyNFTsView(
                    nftIds: viewModel?.profile?.nfts ?? [],
                    favoriteIds: viewModel?.profile?.likes ?? [],
                    nftService: servicesAssembly.nftService,
                    onToggleFavorite: { id in
                        await viewModel?.toggleFavoriteNft(id: id)
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
            case .favoriteNFTs:
                FavoriteNFTsView(
                    nftIds: Binding(
                        get: { viewModel?.profile?.likes ?? [] },
                        set: { _ in }
                    ),
                    nftService: servicesAssembly.nftService,
                    onRemoveFromFavorites: { id in
                        await viewModel?.removeFavoriteNft(id: id)
                    }
                )
                .navigationBarTitleDisplayMode(.inline)
            case .webView:
                if let profileWebsiteURL {
                    WebView(url: profileWebsiteURL)
                } else {
                    EmptyView()
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = ProfileViewModel(
                    profileService: servicesAssembly.profileService,
                    id: "1"
                )
            }
            await viewModel?.loadProfile()
        }
        .onChange(of: viewModel?.errorMessage) { _, newValue in
            if let newValue, !newValue.isEmpty {
                path = []
            }
        }
    }

    private var contentView: some View {
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

    private var loadingView: some View {
        ProgressView()
            .tint(.ypBlack)
            .frame(width: 30, height: 30)
    }

    private func errorView(message: String) -> some View {
        Text(message)
            .font(.system(size: 13, weight: .regular))
            .foregroundStyle(.ypBlack)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
    }

    private var profileName: String { viewModel?.profile?.name ?? "" }

    private var profileDescription: String {
        viewModel?.profile?.description ?? ""
    }

    private var profileWebsiteText: String {
        viewModel?.profile?.website ?? ""
    }

    private var profileWebsiteURL: URL? {
        guard let website = viewModel?.profile?.website else { return nil }
        return URL(string: website)
    }

    private var profileAvatarURL: URL? {
        guard let avatar = viewModel?.profile?.avatar else { return nil }
        return URL(string: avatar)
    }

    private var myNFTCount: Int { viewModel?.profile?.nfts.count ?? .zero }

    private var favoriteNFTCount: Int {
        viewModel?.profile?.likes.count ?? .zero
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                avatar
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
            if profileWebsiteURL != nil {
                Button(action: websiteTapped) {
                    Text(profileWebsiteText)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.ypUBlue)
                        .padding(.top, 8)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var nftMenu: some View {
        VStack(spacing: .zero) {
            nftMenuRow(
                title: "Мои NFT",
                count: myNFTCount,
                action: myNFTsTapped
            )
            nftMenuRow(
                title: "Избранные NFT",
                count: favoriteNFTCount,
                action: favoriteNFTsTapped
            )
        }
    }

    private var avatar: some View {
        Group {
            if let profileAvatarURL {
                AsyncImage(url: profileAvatarURL) { phase in
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
                    default:
                        avatarPlaceholder
                    }
                }
            } else {
                avatarPlaceholder
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }

    private var avatarPlaceholder: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFill()
            .foregroundStyle(.ypBlack)
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
        path.append(.edit)
    }

    private func myNFTsTapped() {
        path.append(.myNFTs)
    }

    private func favoriteNFTsTapped() {
        path.append(.favoriteNFTs)
    }

    private func websiteTapped() {
        guard profileWebsiteURL != nil else { return }
        path.append(.webView)
    }
}

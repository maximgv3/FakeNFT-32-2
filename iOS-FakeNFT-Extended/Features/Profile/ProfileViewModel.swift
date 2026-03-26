import Foundation

@Observable @MainActor
final class ProfileViewModel {

    var isLoading = false
    var errorMessage: String?
    var profile: Profile?

    private let profileService: ProfileService
    private let id: String

    init(profileService: ProfileService, id: String = "1") {
        self.profileService = profileService
        self.id = id
    }

    func loadProfile() async {
        guard profile == nil else { return }

        errorMessage = nil
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            profile = try await profileService.loadProfile(id: id)
        } catch {
            handleError(error)
        }

    }
    func toggleFavoriteNft(id: String) async {
        guard let profile else { return }

        if profile.likes.contains(id) {
            await removeFavoriteNft(id: id)
        } else {
            await addFavoriteNft(id: id)
        }
    }

    func addFavoriteNft(id nftId: String) async {
        await updateFavoriteNft(id: nftId, shouldLike: true)
    }

    func removeFavoriteNft(id nftId: String) async {
        await updateFavoriteNft(id: nftId, shouldLike: false)
    }

    private func updateFavoriteNft(id nftId: String, shouldLike: Bool) async {
        guard let currentProfile = profile else { return }
        guard shouldLike ? !currentProfile.likes.contains(nftId) : currentProfile.likes.contains(nftId) else { return }

        errorMessage = nil

        let updatedLikes = shouldLike
            ? currentProfile.likes + [nftId]
            : currentProfile.likes.filter { $0 != nftId }

        let updatedProfile = Profile(
            id: currentProfile.id,
            name: currentProfile.name,
            avatar: currentProfile.avatar,
            description: currentProfile.description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: updatedLikes
        )

        await updateProfile(updatedProfile)
    }

    private func updateProfile(_ updatedProfile: Profile) async {
        do {
            profile = try await profileService.updateProfile(
                id: id,
                profile: updatedProfile
            )
        } catch {
            handleError(error)
        }
    }

    private func handleError(_ error: Error) {
        errorMessage = ErrorMessageMapper.message(from: error)
    }
}

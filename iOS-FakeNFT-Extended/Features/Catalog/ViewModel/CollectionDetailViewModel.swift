import Foundation

@Observable
@MainActor
final class CollectionDetailViewModel {

    // MARK: - Properties

    var nfts: [Nft] = []
    var isLoading = false
    var showError = false
    var likedNftIds: Set<String> = []
    var cartNftIds: Set<String> = []

    private let collection: NftCollection
    private let collectionDetailService: CollectionDetailService
    private let profileService: ProfileService
    private let cartService: CartServiceProtocol

    // MARK: - Init

    init(
        collection: NftCollection,
        collectionDetailService: CollectionDetailService,
        profileService: ProfileService,
        cartService: CartServiceProtocol
    ) {
        self.collection = collection
        self.collectionDetailService = collectionDetailService
        self.profileService = profileService
        self.cartService = cartService
    }

    // MARK: - Public

    func loadNfts() async {
        isLoading = true
        do {
            async let nftsResult = collectionDetailService.loadNfts(ids: collection.nfts)
            async let profileResult = profileService.loadProfile(id: "1")
            async let cartResult = cartService.loadCartItems()

            let (loadedNfts, profile, cart) = try await (nftsResult, profileResult, cartResult)

            nfts = loadedNfts
            likedNftIds = Set(profile.likes)
            cartNftIds = Set(cart.0.map { $0.id })
        } catch {
            showError = true
        }
        isLoading = false
    }

    func toggleLike(nftId: String) async {
        let wasLiked = likedNftIds.contains(nftId)
        if wasLiked {
            likedNftIds.remove(nftId)
        } else {
            likedNftIds.insert(nftId)
        }
        do {
            let profile = try await profileService.loadProfile(id: "1")
            var updatedLikes = profile.likes
            if wasLiked {
                updatedLikes.removeAll { $0 == nftId }
            } else {
                if !updatedLikes.contains(nftId) {
                    updatedLikes.append(nftId)
                }
            }
            let updatedProfile = Profile(
                id: profile.id,
                name: profile.name,
                avatar: profile.avatar,
                description: profile.description,
                website: profile.website,
                nfts: profile.nfts,
                likes: updatedLikes
            )
            let saved = try await profileService.updateProfile(id: "1", profile: updatedProfile)
            likedNftIds = Set(saved.likes)
            NotificationCenter.default.post(name: .likesDidUpdate, object: nil)
        } catch {
            if wasLiked {
                likedNftIds.insert(nftId)
            } else {
                likedNftIds.remove(nftId)
            }
            showError = true
        }
    }

    func toggleCart(nftId: String) async {
        let isInCart = cartNftIds.contains(nftId)
        if isInCart {
            cartNftIds.remove(nftId)
        } else {
            cartNftIds.insert(nftId)
        }
        do {
            if isInCart {
                let (items, _) = try await cartService.removeItem(id: nftId)
                cartNftIds = Set(items.map { $0.id })
            } else {
                let (items, _) = try await cartService.addItem(id: nftId)
                cartNftIds = Set(items.map { $0.id })
            }
            NotificationCenter.default.post(name: .cartDidUpdate, object: nil)
        } catch {
            if isInCart {
                cartNftIds.insert(nftId)
            } else {
                cartNftIds.remove(nftId)
            }
            showError = true
        }
    }
}

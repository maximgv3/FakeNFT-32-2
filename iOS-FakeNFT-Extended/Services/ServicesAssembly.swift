import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    
    let networkClient: NetworkClient
    let nftStorage: NftStorage
    let nftService: NftService
    let cartService: CartServiceProtocol
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        
        let nftService = NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
        self.nftService = nftService
        
        self.cartService = CartServiceImpl(
            networkClient: networkClient,
            nftService: nftService
        )
    }
}

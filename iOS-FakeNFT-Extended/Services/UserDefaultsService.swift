import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard

    private init() {}

    private enum Key {
        static let myNFTsSortOption = "myNFTs.sortOption"
    }

    var myNFTsSortOption: String? {
        get { defaults.string(forKey: Key.myNFTsSortOption) }
        set { defaults.set(newValue, forKey: Key.myNFTsSortOption) }
    }
}

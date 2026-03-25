import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    private init() {}

    private enum Key {
        static let sortOption = "catalogSortOption"
    }

    var sortOption: SortOption? {
        get {
            switch defaults.string(forKey: Key.sortOption) {
            case "byName": .byName
            case "byNFTCount": .byNFTCount
            default: nil
            }
        }
        set {
            switch newValue {
            case .byName:
                defaults.set("byName", forKey: Key.sortOption)
            case .byNFTCount:
                defaults.set("byNFTCount", forKey: Key.sortOption)
            case nil:
                defaults.removeObject(forKey: Key.sortOption)
            }
        }
    }
}

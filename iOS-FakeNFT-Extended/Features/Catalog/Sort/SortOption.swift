enum SortOption {
    case byName
    case byNFTCount

    var title: String {
        switch self {
        case .byName: return "По названию"
        case .byNFTCount: return "По количеству NFT"
        }
    }
}

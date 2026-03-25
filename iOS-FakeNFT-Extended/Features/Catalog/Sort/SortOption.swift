enum SortOption: Equatable {
    case byName
    case byNFTCount

    var title: String {
        switch self {
        case .byName: "По названию"
        case .byNFTCount: "По количеству NFT"
        }
    }
}

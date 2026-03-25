import Foundation

struct Nft: Codable, Sendable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
}

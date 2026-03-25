import Foundation

struct Nft: Codable, Sendable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
}

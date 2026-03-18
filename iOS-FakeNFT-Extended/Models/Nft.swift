import Foundation

struct Nft: Decodable, Sendable, Identifiable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String
    let id: String
}

extension Nft {
    static let mock = Nft(
        createdAt: "2026-03-18T12:00:00Z",
        name: "Lilo",
        images: ["mock_2"],
        rating: 5,
        description: "Mock NFT for My NFT screen",
        price: 1.78,
        author: "John Doe",
        website: "https://example.com",
        id: "mock-2"
    )

    static let mockSpring = Nft(
        createdAt: "2026-03-18T12:00:00Z",
        name: "Spring",
        images: ["mock_3"],
        rating: 3,
        description: "Mock NFT for My NFT screen",
        price: 1.28,
        author: "John Doe",
        website: "https://example.com",
        id: "mock-3"
    )

    static let mockApril = Nft(
        createdAt: "2026-03-18T12:00:00Z",
        name: "April",
        images: ["mock_4"],
        rating: 4,
        description: "Mock NFT for My NFT screen",
        price: 1.98,
        author: "John Doe",
        website: "https://example.com",
        id: "mock-4"
    )

    static let mocks: [Nft] = [mock, mockSpring, mockApril]
}

import Foundation

protocol ProfileService {
    func loadProfile(id: String) async throws -> Profile
}

actor ProfileServiceImpl: ProfileService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(id: String) async throws -> Profile {
        let request = ProfileRequest(id: id)
        return try await networkClient.send(request: request)
    }
}

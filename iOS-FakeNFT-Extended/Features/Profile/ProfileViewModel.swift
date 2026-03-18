import Foundation

@Observable @MainActor
final class ProfileViewModel {
    
    var isLoading = false
    var errorMessage: String?
    var profile: Profile?

    private let profileService: ProfileService
    private let id: String
    
    init(profileService: ProfileService, id: String = "1") {
        self.profileService = profileService
        self.id = id
    }
    
    func loadProfile() async {
        guard profile == nil else { return }
        
        errorMessage = nil
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            profile = try await profileService.loadProfile(id: id)
        } catch let error as NetworkClientError {
            switch error {
            case .httpStatusCode(let code):
                errorMessage = "HTTP error: \(code)"
            case .urlRequestError(let error):
                errorMessage = "Request error: \(error.localizedDescription)"
            case .urlSessionError:
                errorMessage = "URL session error"
            case .parsingError:
                errorMessage = "Parsing error"
            case .incorrectRequest(let message):
                errorMessage = "Incorrect request: \(message)"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
}

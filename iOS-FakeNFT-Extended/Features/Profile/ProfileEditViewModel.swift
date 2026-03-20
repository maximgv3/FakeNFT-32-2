import Foundation
import Observation

@Observable
@MainActor
final class ProfileEditViewModel {
    
    private let profileService: ProfileService
    private let profileId: String
    private let likes: [String]
    private let nfts: [String]
    private var initialPhotoURL: URL?
    private var initialName: String
    private var initialDescription: String
    private var initialWebsite: String
    var photoUrl: URL?
    var previousPhotoUrl: URL?
    var nameText: String
    var descriptionText: String
    var siteText: String
    var isLoading = false
    var errorMessage: String?

    var isSaveErrorPresented: Bool {
        errorMessage != nil
    }

    var hasChanges: Bool {
        let trimmedName = nameText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWebsite = siteText.trimmingCharacters(in: .whitespacesAndNewlines)

        return photoUrl != initialPhotoURL ||
            trimmedName != initialName ||
            trimmedDescription != initialDescription ||
            trimmedWebsite != initialWebsite
    }

    init(profile: Profile, profileService: ProfileService) {
        self.photoUrl = URL(string: profile.avatar)
        self.previousPhotoUrl = nil
        self.nameText = profile.name
        self.descriptionText = profile.description ?? ""
        self.siteText = profile.website
        
        self.profileService = profileService
        self.profileId = "1"
        self.likes = profile.likes
        self.nfts = profile.nfts
        
        self.initialPhotoURL = URL(string: profile.avatar)
        self.initialName = profile.name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.initialDescription = (profile.description ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.initialWebsite = profile.website.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func deletePhoto() {
        photoUrl = nil
    }

    func applyPhotoLink(_ input: String) -> Bool {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedInput = normalizePhotoURLString(trimmedInput)

        guard let url = URL(string: normalizedInput),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme),
              let host = url.host,
              !host.isEmpty else {
            return false
        }

        previousPhotoUrl = photoUrl
        photoUrl = url
        return true
    }

    func restorePreviousPhoto() {
        photoUrl = previousPhotoUrl
        previousPhotoUrl = nil
    }

    func saveProfile() async throws -> Profile {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        let updatedProfile = Profile(
            id: profileId,
            name: nameText.trimmingCharacters(in: .whitespacesAndNewlines),
            avatar: photoUrl?.absoluteString ?? "",
            description: descriptionText.trimmingCharacters(in: .whitespacesAndNewlines),
            website: siteText.trimmingCharacters(in: .whitespacesAndNewlines),
            nfts: nfts,
            likes: likes
        )

        do {
            let savedProfile = try await profileService.updateProfile(id: profileId, profile: updatedProfile)
            photoUrl = URL(string: savedProfile.avatar)
            previousPhotoUrl = nil
            nameText = savedProfile.name
            descriptionText = savedProfile.description ?? ""
            siteText = savedProfile.website

            initialPhotoURL = URL(string: savedProfile.avatar)
            initialName = savedProfile.name.trimmingCharacters(in: .whitespacesAndNewlines)
            initialDescription = (savedProfile.description ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            initialWebsite = savedProfile.website.trimmingCharacters(in: .whitespacesAndNewlines)

            return savedProfile
        } catch {
            errorMessage = makeErrorMessage(from: error)
            throw error
        }
    }

    func dismissSaveError() {
        errorMessage = nil
    }

    private func makeErrorMessage(from error: Error) -> String {
        if let error = error as? NetworkClientError {
            switch error {
            case .httpStatusCode(let code):
                return "HTTP error: \(code)"
            case .urlRequestError(let error):
                return "Request error: \(error.localizedDescription)"
            case .urlSessionError:
                return "URL session error"
            case .parsingError:
                return "Parsing error"
            case .incorrectRequest(let message):
                return "Incorrect request: \(message)"
            }
        }

        return error.localizedDescription
    }

    private func normalizePhotoURLString(_ input: String) -> String {
        guard !input.isEmpty else { return input }

        if input.lowercased().hasPrefix("http://") ||
            input.lowercased().hasPrefix("https://") {
            return input
        }

        return "https://\(input)"
    }
}

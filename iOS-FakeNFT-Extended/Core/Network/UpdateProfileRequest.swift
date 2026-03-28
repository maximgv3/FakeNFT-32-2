import Foundation

struct UpdateProfileRequest: NetworkRequest {

    var headers: [String: String] {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
    var body: Data? {
        var components: [String] = []

        components.append("name=\(encode(profile.name))")
        components.append("description=\(encode(profile.description ?? ""))")
        components.append("avatar=\(encode(profile.avatar))")
        components.append("website=\(encode(profile.website))")

        if profile.likes.isEmpty {
            components.append("likes=null")
        } else {
            for like in profile.likes {
                components.append("likes=\(encode(like))")
            }
        }

        return components.joined(separator: "&").data(using: .utf8)
    }
    
    let id: String
    let profile: Profile
    let httpMethod: HttpMethod = .put
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }

    private func encode(_ value: String) -> String {
        value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
    }
}

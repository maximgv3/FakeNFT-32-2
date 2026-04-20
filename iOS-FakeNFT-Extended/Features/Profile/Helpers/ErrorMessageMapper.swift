import Foundation

enum ErrorMessageMapper {
    static func message(from error: Error) -> String {
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
}

import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case incorrectRequest(String)
}

protocol NetworkClient {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest) async throws -> T
}

actor DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func send(request: NetworkRequest) async throws -> Data {
        let urlRequest = try create(request: request)
        let (data, response) = try await session.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }

        guard (200...299).contains(response.statusCode) else {
            throw NetworkClientError.httpStatusCode(response.statusCode)
        }

        return data
    }

    func send<T: Decodable>(request: NetworkRequest) async throws -> T {
        let data = try await send(request: request)
        return try await parse(data: data)
    }

    // MARK: - Private

    private func create(request: NetworkRequest) throws -> URLRequest {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue

        configureBody(for: request, in: &urlRequest)
        addHeaders(to: &urlRequest)

        return urlRequest
    }

    private func configureBody(for request: NetworkRequest, in urlRequest: inout URLRequest) {
        if let updateOrderRequest = request as? UpdateOrderRequest {
            configureFormBody(updateOrderRequest, in: &urlRequest)
            return
        }

        if let dto = request.dto,
           let data = try? encoder.encode(dto) {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
        }
    }

    private func configureFormBody(_ request: UpdateOrderRequest, in urlRequest: inout URLRequest) {
        let bodyString = request.nfts
            .map {
                let encoded = $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0
                return "nfts=\(encoded)"
            }
            .joined(separator: "&")

        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = bodyString.data(using: .utf8)
    }

    private func addHeaders(to urlRequest: inout URLRequest) {
        urlRequest.addValue(
            RequestConstants.token,
            forHTTPHeaderField: "X-Practicum-Mobile-Token"
        )
    }

    private func parse<T: Decodable>(data: Data) async throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }
}

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
        
        // 🔍 Детальное логирование запроса
        print("\n========== 📤 REQUEST ==========")
        print("URL: \(urlRequest.url?.absoluteString ?? "nil")")
        print("Method: \(urlRequest.httpMethod ?? "nil")")
        print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        if let body = urlRequest.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "nil")")
        }
        print("================================\n")
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }
        
        // 🔍 Детальное логирование ответа
        print("\n========== 📥 RESPONSE ==========")
        print("Status: \(response.statusCode)")
        let responseString = String(data: data, encoding: .utf8) ?? "nil"
        print("Body: \(responseString)")
        print("================================\n")
        
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

        if let body = request.body {
            urlRequest.httpBody = body
            for (headerField, value) in request.headers {
                urlRequest.setValue(value, forHTTPHeaderField: headerField)
            }
        } else if let dto = request.dto,
                  let dtoEncoded = try? encoder.encode(dto) {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = dtoEncoded
        }

        addHeaders(to: &urlRequest)
        
        return urlRequest
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

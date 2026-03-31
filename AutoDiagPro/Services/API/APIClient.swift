import Foundation

// MARK: - API Configuration
enum APIConfig {
    #if DEBUG
    static let baseURL = "https://app-ddkdjioq.fly.dev"
    #else
    static let baseURL = "https://app-ddkdjioq.fly.dev"
    #endif
    
    static let timeout: TimeInterval = 15.0
}

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidRequest
    case networkError(Error)
    case serverError(Int, String)
    case decodingError(Error)
    case noData
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalid"
        case .invalidRequest:
            return "Cerere invalida"
        case .networkError(let error):
            return "Eroare retea: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Eroare server (\(code)): \(message)"
        case .decodingError:
            return "Eroare la procesarea raspunsului"
        case .noData:
            return "Nu s-au primit date de la server"
        case .timeout:
            return "Conexiunea a expirat. Verificati conexiunea la internet."
        }
    }
}

// MARK: - API Client
final class APIClient {
    static let shared = APIClient()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.timeout
        config.timeoutIntervalForResource = APIConfig.timeout * 2
        config.waitsForConnectivity = true
        session = URLSession(configuration: config)
        
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    // MARK: - Generic POST Request
    func post<T: Encodable, R: Decodable>(
        endpoint: String,
        body: T,
        responseType: R.Type
    ) async throws -> R {
        guard let url = URL(string: "\(APIConfig.baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("AutoDiagPro/1.0 iOS", forHTTPHeaderField: "User-Agent")
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw APIError.invalidRequest
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .timedOut {
            throw APIError.timeout
        } catch {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(httpResponse.statusCode, message)
        }
        
        do {
            return try decoder.decode(R.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - Generic GET Request
    func get<R: Decodable>(
        endpoint: String,
        responseType: R.Type
    ) async throws -> R {
        guard let url = URL(string: "\(APIConfig.baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("AutoDiagPro/1.0 iOS", forHTTPHeaderField: "User-Agent")
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .timedOut {
            throw APIError.timeout
        } catch {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(httpResponse.statusCode, message)
        }
        
        do {
            return try decoder.decode(R.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - Health Check
    func healthCheck() async -> Bool {
        do {
            struct HealthResponse: Decodable { let status: String }
            let result = try await get(endpoint: "/healthz", responseType: HealthResponse.self)
            return result.status == "ok"
        } catch {
            return false
        }
    }
}

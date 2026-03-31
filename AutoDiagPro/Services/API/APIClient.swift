import Foundation
import os.log

// MARK: - Environment Configuration
enum APIEnvironment: String {
    case development
    case production
    
    var baseURL: String {
        switch self {
        case .development:
            return "http://localhost:8000"
        case .production:
            return "https://app-ddkdjioq.fly.dev"
        }
    }
}

// MARK: - API Configuration
enum APIConfig {
    #if DEBUG
    static var environment: APIEnvironment = .production
    #else
    static let environment: APIEnvironment = .production
    #endif
    
    static var baseURL: String { environment.baseURL }
    static let timeout: TimeInterval = 15.0
    static let maxRetries: Int = 3
    static let retryBaseDelay: TimeInterval = 1.0
    static let userAgent = "AutoDiagPro/1.0 iOS"
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
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
    case maxRetriesExceeded(lastError: Error)
    
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
        case .maxRetriesExceeded(let lastError):
            return "Cererea a esuat dupa \(APIConfig.maxRetries) incercari: \(lastError.localizedDescription)"
        }
    }
    
    /// Whether this error is retryable (network, timeout, server 5xx/429)
    var isRetryable: Bool {
        switch self {
        case .timeout, .networkError:
            return true
        case .serverError(let code, _):
            return code >= 500 || code == 429
        default:
            return false
        }
    }
}

// MARK: - Request Builder
struct APIRequest {
    let method: HTTPMethod
    let endpoint: String
    var headers: [String: String] = [:]
    var body: Data?
    var queryItems: [URLQueryItem]?
    var retryCount: Int = APIConfig.maxRetries
    
    /// Build a POST request with an Encodable body
    static func post<T: Encodable>(
        endpoint: String,
        body: T,
        encoder: JSONEncoder
    ) throws -> APIRequest {
        let data = try encoder.encode(body)
        return APIRequest(
            method: .post,
            endpoint: endpoint,
            headers: ["Content-Type": "application/json"],
            body: data
        )
    }
    
    /// Build a GET request with optional query parameters
    static func get(
        endpoint: String,
        queryItems: [URLQueryItem]? = nil
    ) -> APIRequest {
        return APIRequest(
            method: .get,
            endpoint: endpoint,
            queryItems: queryItems
        )
    }
}

// MARK: - Debug Logger
private enum APILogger {
    private static let logger = Logger(subsystem: "com.autodiagpro", category: "API")
    
    static func logRequest(_ request: URLRequest, apiRequest: APIRequest) {
        #if DEBUG
        let method = apiRequest.method.rawValue
        let url = request.url?.absoluteString ?? "unknown"
        logger.debug("➡️ [\(method)] \(url)")
        if let body = apiRequest.body, let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("   Body: \(bodyString)")
        }
        #endif
    }
    
    static func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval) {
        #if DEBUG
        let status = response.statusCode
        let size = data.count
        let ms = Int(duration * 1000)
        logger.debug("⬅️ Response: \(status) (\(size) bytes, \(ms)ms)")
        if !(200...299).contains(status), let body = String(data: data, encoding: .utf8) {
            logger.error("   Error body: \(body)")
        }
        #endif
    }
    
    static func logRetry(attempt: Int, maxRetries: Int, delay: TimeInterval, error: Error) {
        #if DEBUG
        logger.warning("🔄 Retry \(attempt)/\(maxRetries) after \(String(format: "%.1f", delay))s — \(error.localizedDescription)")
        #endif
    }
    
    static func logError(_ error: Error) {
        #if DEBUG
        logger.error("❌ Failed: \(error.localizedDescription)")
        #endif
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
    
    // MARK: - Core: Execute Request with Retry + Logging
    private func execute<R: Decodable>(
        _ apiRequest: APIRequest,
        responseType: R.Type
    ) async throws -> R {
        guard var components = URLComponents(string: "\(APIConfig.baseURL)\(apiRequest.endpoint)") else {
            throw APIError.invalidURL
        }
        if let queryItems = apiRequest.queryItems {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue
        urlRequest.setValue(APIConfig.userAgent, forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        for (key, value) in apiRequest.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.httpBody = apiRequest.body
        
        APILogger.logRequest(urlRequest, apiRequest: apiRequest)
        
        var lastError: Error = APIError.noData
        let maxRetries = apiRequest.retryCount
        
        for attempt in 0...maxRetries {
            if attempt > 0 {
                let delay = APIConfig.retryBaseDelay * pow(2.0, Double(attempt - 1))
                APILogger.logRetry(attempt: attempt, maxRetries: maxRetries, delay: delay, error: lastError)
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            do {
                let startTime = CFAbsoluteTimeGetCurrent()
                let (data, response) = try await session.data(for: urlRequest)
                let duration = CFAbsoluteTimeGetCurrent() - startTime
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.noData
                }
                
                APILogger.logResponse(httpResponse, data: data, duration: duration)
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                    let error = APIError.serverError(httpResponse.statusCode, message)
                    if error.isRetryable && attempt < maxRetries {
                        lastError = error
                        continue
                    }
                    throw error
                }
                
                return try decoder.decode(R.self, from: data)
                
            } catch let error as URLError where error.code == .timedOut {
                lastError = APIError.timeout
                if attempt < maxRetries { continue }
                throw APIError.timeout
            } catch let error as APIError where error.isRetryable {
                lastError = error
                if attempt < maxRetries { continue }
                throw error
            } catch let error as APIError {
                throw error
            } catch let error as DecodingError {
                throw APIError.decodingError(error)
            } catch {
                lastError = error
                if attempt < maxRetries { continue }
                throw APIError.networkError(error)
            }
        }
        
        throw APIError.maxRetriesExceeded(lastError: lastError)
    }
    
    // MARK: - Convenience: POST
    func post<T: Encodable, R: Decodable>(
        endpoint: String,
        body: T,
        responseType: R.Type
    ) async throws -> R {
        do {
            let apiRequest = try APIRequest.post(endpoint: endpoint, body: body, encoder: encoder)
            return try await execute(apiRequest, responseType: responseType)
        } catch let error as EncodingError {
            throw APIError.invalidRequest
        }
    }
    
    // MARK: - Convenience: GET
    func get<R: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem]? = nil,
        responseType: R.Type
    ) async throws -> R {
        let apiRequest = APIRequest.get(endpoint: endpoint, queryItems: queryItems)
        return try await execute(apiRequest, responseType: responseType)
    }
    
    // MARK: - Health Check
    func healthCheck() async -> Bool {
        do {
            struct HealthResponse: Decodable { let status: String }
            let result = try await get(endpoint: "/healthz", responseType: HealthResponse.self)
            return result.status == "ok"
        } catch {
            APILogger.logError(error)
            return false
        }
    }
}

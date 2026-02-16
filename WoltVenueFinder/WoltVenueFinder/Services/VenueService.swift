//
//  VenueService.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//

import Foundation
/// Protocol defining the venue service interface
/// Enables dependency injection and easy testing with mock implementations
///
/// Why Protocol?
/// - Testing: Can create MockVenueService for unit tests
/// - Flexibility: Can swap implementations (e.g., CachedVenueService)
/// - SOLID principles: Depend on abstractions, not concretions

protocol VenueServiceProtocol {
    /// Fetches nearby venues based on user's location
    /// - Parameters:
    ///   - latitude: User's current latitude
    ///   - longitude: User's current longitude
    /// - Returns: Array of venue items (limited to max display count)
    /// - Throws: VenueServiceError if request fails
    
    func fetchVenues(latitude: Double,
                     longitude: Double) async throws -> [VenueItem]
}


/// Custom errors for venue service operations
/// Provides specific, actionable error information
///
/// Why Custom Error Enum?
/// - User-friendly messages (LocalizedError)
/// - Specific error handling in UI (network vs parsing)
/// - Better debugging (know exactly what failed)
enum VenueServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    case invalidResponse
    
    /// Human-readable error descriptions for UI display
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint configuration"
        case .networkError(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .noData:
            return "No data received from server"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
    
    /// Detailed failure reasons for debugging
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The API URL could not be constructed with the provided parameters"
        case .networkError:
            return "Check your internet connection and try again"
        case .decodingError:
            return "The server response format has changed or is malformed"
        case .noData:
            return "The server returned an empty response"
        case .invalidResponse:
            return "The server returned an unexpected HTTP status code"
        }
    }
}

/// Service responsible for fetching venue data from Wolt API
/// Uses modern async/await concurrency for clean, readable network code
///
/// Architecture Decision: Why Class not Struct?
/// - Reference semantics: Share single instance across app
/// - Potential for future state (caching, request deduplication)
/// - ObservableObject if needed later
final class VenueService: VenueServiceProtocol {
    // MARK: - Properties
    
    /// URLSession instance for network requests
    /// Injected for testability (can pass mock session in tests)
    ///
    /// Why Private?
    /// - Encapsulation: Implementation detail
    /// - Only this class needs to know about URLSession
    private var session: URLSession
    
    /// JSONDecoder configured for API response parsing
    /// Reused across requests for efficiency
    ///
    /// Why Lazy?
    /// - Only created if/when needed
    /// - Configuration happens once, reused many times
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // Add custom configuration here if needed
        // e.g., decoder.keyDecodingStrategy = .convertFromSnakeCase
        // But we're using CodingKeys, so not needed
        return decoder
    }()
    
    // MARK: - Initialization
    
    /// Initializes the venue service with optional custom URLSession
    /// - Parameter session: URLSession to use (defaults to shared)
    ///
    /// Why Default Parameter?
    /// - Production: VenueService() uses URLSession.shared
    /// - Testing: VenueService(session: mockSession) uses mock
    /// - Best of both worlds: convenience + testability
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    
    /// Fetches venues near the specified coordinates
    /// - Parameters:
    ///   - latitude: Latitude coordinate (-90 to 90)
    ///   - longitude: Longitude coordinate (-180 to 180)
    /// - Returns: Array of venue items limited to maximum display count
    /// - Throws: VenueServiceError for any failure
    ///
    /// Implementation Notes:
    /// - Uses async/await for clean concurrency (no callback hell)
    /// - Throws specific errors for better error handling
    /// - Applies business rule: max 15 venues from Constants
    func fetchVenues(latitude: Double,
                     longitude: Double) async throws -> [VenueItem] {
        // Step 1: Construct the API URL
        guard let url = buildURL(latitude: latitude,
                                 longitude: longitude) else {
            throw VenueServiceError.invalidURL
            
        }
        // Step 2: Create URL request with timeout
        var request = URLRequest(url: url)
        request.timeoutInterval = Constants.API.requestTimeout
        request.httpMethod = "GET"
        // Add headers if needed:
        // request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Step 3: Perform network request (async)
        let(data, response) = try await session.data(for: request)
        
        // Step 4: Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw VenueServiceError.invalidResponse
        }
        
        // Check for success status code (200-299)
        guard (200...299).contains(httpResponse.statusCode) else {
            throw VenueServiceError.networkError(
                NSError(domain: "HTTPError",
                        code: httpResponse.statusCode)
            )
        }
        // Step 5: Ensure we received data
        guard !data.isEmpty else {
            throw VenueServiceError.noData
        }
        
        // Step 6: Decode JSON to VenueResponse
        let venueResponse: VenueResponse
        do {
            venueResponse = try decoder.decode(VenueResponse.self, from: data)
        } catch {
            throw VenueServiceError.decodingError(error)
        }
        
        // Step 7: Apply business logic - limit to max venues
        let limitedVenues = venueResponse.limitedVenueItems(
            to: Constants.API.maxVenuesToDisplay
        )
        
        return limitedVenues
    }
    
    // MARK: - Private Helpers
    
    /// Constructs the API URL with query parameters
    /// - Parameters:
    ///   - latitude: Latitude coordinate
    ///   - longitude: Longitude coordinate
    /// - Returns: Complete URL with query parameters, or nil if invalid
    ///
    /// Why Private Method?
    /// - Single Responsibility: URL construction is separate concern
    /// - Testable: Can test URL building in isolation
    /// - Reusable: If we add more endpoints, same pattern
    
    private func buildURL(latitude: Double,
                  longitude: Double) -> URL? {
        // Use URLComponents for safe URL construction
        // Handles encoding of special characters automatically
        guard var components = URLComponents(string: Constants.API.baseURL) else {
            return nil
        }
        // Add query parameters
        // Format: ?lat=60.17&lon=24.93
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(format: "%.6f", latitude)),
            URLQueryItem(name: "lon", value: String(format: "%.6f", longitude))
        ]
        
        return components.url
    }
}

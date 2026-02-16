//
//  VenueListViewModel.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//

import Combine
import Foundation
import SwiftUI

/// ViewModel for the main venue list screen
/// Manages venue data, loading states, location updates, and favorites integration
///
/// Architecture:
/// - ObservableObject: SwiftUI views observe this
/// - @Published: Auto-updates UI when properties change
/// - Combine: Reactive subscriptions to location and favorites
/// - async/await: Clean network calls
///
/// Why ViewModel Pattern?
/// - Separates business logic from UI
/// - Testable without SwiftUI
/// - Reusable across different views
/// - Single source of truth for state

@MainActor
final class VenueListViewModel: ObservableObject {
    // MARK: - Published Properties (UI State)
    
    /// Array of venues to display
    /// Published so SwiftUI List automatically updates
    @Published private(set) var venues: [VenueItem] = []
    
    /// Loading state for showing skeleton screens
    /// true when fetching data, false when done
    @Published private(set) var isLoading = false
    
    /// Error message to display to user
    /// nil when no error, set when fetch fails
    @Published private(set) var errorMessage: String?
    
    /// Current location coordinates
    /// Updates every 10 seconds from LocationSimulator
    @Published private(set) var currentLocation:
    (
        latitude: Double,
        longitude: Double
    )

    /// Set of favorite venue IDs
    /// Mirrors FavouritesManager for reactive UI updates
    /// When this changes, VenueRow heart icons auto-update
    @Published private(set) var favoriteIDs: Set<String> = []

    /// Service for fetching venues from API
    /// Injected for testability (can pass MockVenueService)
    private let venueService: VenueServiceProtocol
    
    /// Manager for favorites persistence
    /// Injected for testability
    private let favouritesManager: FavouritesManager
    
    /// Simulates user movement through Helsinki
    /// Updates location every 10 seconds
    private let locationSimulator: LocationSimulator
    
    /// Set of Combine subscriptions
    /// Stored so subscriptions aren't deallocated
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the view model with dependencies
    /// - Parameters:
    ///   - venueService: Service for API calls (defaults to real implementation)
    ///   - favoritesManager: Manager for favorites (defaults to real implementation)
    ///   - locationSimulator: Simulator for location (defaults to real implementation)
    ///
    /// Why Default Parameters?
    /// - Production: VenueListViewModel() uses real services
    /// - Testing: Can inject mocks
    /// - Previews: Can use preview data
    
    init(
        venueService: VenueServiceProtocol,
        favouritesManager: FavouritesManager,
        locationSimulator: LocationSimulator) {
        self.venueService = venueService
        self.favouritesManager = favouritesManager
        self.locationSimulator = locationSimulator
        self.currentLocation = locationSimulator.currentLocation

        // Initialize favorites from manager
        self.favoriteIDs = favouritesManager.favouriteIDs

        //Setup reactive subscriptions
        setupSubscription()
    }
    
    /// Creates a view model with production dependencies
    /// Call this in your views: @StateObject var viewModel = VenueListViewModel.live()
    ///
    /// Why Static Factory?
    /// - Handles @MainActor initialization correctly
    /// - Clean call site
    /// - Easy to swap for previews/tests

    static func live() -> VenueListViewModel {
        VenueListViewModel(venueService: VenueService(),
                           favouritesManager: .shared,
                           locationSimulator: LocationSimulator())
    }
    
    // MARK: - Public Methods
    
    /// Fetches venues from API based on current location
    /// Called on view appear and when location changes
    ///
    /// Why async?
    /// - Network call is asynchronous
    /// - Can use try/catch for error handling
    /// - Clean, sequential code flow
    func fetchVenues() async {
        // Set loading state
        isLoading = true
        errorMessage = nil

        // DEBUG: Print location
        //print("🔍 Fetching venues at: \(currentLocation.latitude), \(currentLocation.longitude)")

        do {
            // Fetch venues from API
            let fetchedVenues =
            try await venueService
                .fetchVenues(
                    latitude: currentLocation.latitude,
                    longitude: currentLocation.longitude
                )

            // DEBUG: Print results
            //print("✅ Fetched \(fetchedVenues.count) venues")
            if let first = fetchedVenues.first {
                print("First venue: \(first.name)")
            }

            // Update state on main thread (automatically handled by @MainActor)
            venues = fetchedVenues
        } catch let error as VenueServiceError {
            // Handle specific service errors
            errorMessage = error.errorDescription
        } catch let urlError as URLError where urlError.code == .cancelled {
            // Ignore URL cancellation errors (user cancelled pull-to-refresh)
            // This is normal behavior, not an error
            print("ℹ️ Request cancelled - this is normal")
        } catch is CancellationError {
            // Ignore task cancellation errors
            print("ℹ️ Task cancelled - this is normal")
        } catch {
            // Handle unexpected errors
            print("❌ Unexpected error: \(error)")
            errorMessage =
            "An unexpected error occurred: \(error.localizedDescription)"
        }
        // clear loading state
        isLoading = false
    }
    
    /// Starts location simulation and auto-refresh
    /// Called when view appears
    ///
    /// Flow:
    /// 1. Starts timer (updates location every 10s)
    /// 2. Each location update triggers fetchVenues()
    /// 3. UI shows new venues based on new location
    func startLocationUpdates() {
        locationSimulator.startSimulation()
    }
    
    /// Stops location simulation
    /// Called when view disappears (memory management)
    func stopLocationUpdates() {
        locationSimulator.stopSimulation()
    }
    
    /// Toggles favorite status for a venue
    /// - Parameter venueID: ID of the venue to toggle
    ///
    /// Why in ViewModel not View?
    /// - Business logic belongs in ViewModel
    /// - ViewModel coordinates between services
    /// - Keeps view thin and declarative
    func toggleFavourite(venueID: String) {
        favouritesManager.toggleFavorite(venueID: venueID)
    }
    
    /// Checks if a venue is favorited
    /// - Parameter venueID: ID of the venue to check
    /// - Returns: true if favorited, false otherwise
    ///
    /// Why needed?
    /// - View needs to know which heart icon to show (filled vs outline)
    /// - O(1) lookup thanks to Set in FavoritesManager
    func isFavourite(venueID: String) -> Bool {
        favouritesManager.isFavourite(venueID: venueID)
    }
    
    /// Retries fetching venues after an error
    /// Called when user taps "Retry" button
    func retry() {
        Task {
            await fetchVenues()
        }
    }
    
    // MARK: - Private Helpers
    
    /// Sets up Combine subscriptions for reactive updates
    ///
    /// Subscriptions:
    /// 1. Location changes → Auto-fetch new venues
    /// 2. Favorites changes → UI updates heart icons
    ///
    /// Why Combine here?
    /// - Location updates are a stream of events (reactive)
    /// - Automatic UI updates when favorites change
    /// - Clean separation: LocationSimulator doesn't know about ViewModel
    private func setupSubscription() {
        // Subscribe to location changes
        // Every 10 seconds, location updates and we fetch new venues
        locationSimulator
            .$currentLocation
            .dropFirst() // Skip initial value (we fetch manually on appear)
            .sink { [weak self]  newLocation in
                guard let self = self else {
                    return
                }
                // Update current location
                self.currentLocation = newLocation
                
                // Fetch venues for new location
                Task { @MainActor in
                    await self.fetchVenues()
                    
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to favorites changes
        // When favorites change, sync to local @Published property
        // This triggers SwiftUI to re-evaluate isFavourite() calls in views
        favouritesManager.$favouriteIDs.sink { [weak self] newFavorites in
            self?.favoriteIDs = newFavorites
        }
        .store(in: &cancellables)
    }
}

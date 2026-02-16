//
//  FavoritesViewModel.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//

import Foundation
import Combine
import SwiftUI

/// ViewModel for the favorites screen
/// Manages favorite venues list and removal operations
///
/// Architecture:
/// - Simpler than VenueListViewModel (no API calls, just displays saved data)
/// - Observes FavoritesManager for reactive updates
/// - Coordinates with VenueService to fetch full venue data if needed
///
/// Why Separate ViewModel?
/// - Single Responsibility: Each screen has its own logic
/// - Different state management (no loading, location, etc.)
/// - Could add favorites-specific features (sort, filter, search)

@MainActor
final class FavouritesViewModel: ObservableObject {
    /// Array of favorite venue items to display
    /// Filtered from main venues list based on favoriteIDs
    @Published private(set) var favouritesVenues: [VenueItem] = []
    
    /// Whether there are any favorites
    /// Used to show/hide empty state
    @Published private(set) var hasFavourites: Bool = false
    
    /// Manager for favorites persistence
    /// Source of truth for favorite IDs
    private let favouritesManager: FavouritesManager
    
    /// Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the favorites view model
    /// - Parameter favoritesManager: Manager for favorites (defaults to real implementation)
    ///
    /// Why Simpler Than VenueListViewModel?
    /// - No VenueService needed (we get venues from parent view)
    /// - No LocationSimulator needed (favorites don't depend on location)
    /// - Just observes FavoritesManager state
    init(favouritesManager: FavouritesManager) {
        self.favouritesManager = favouritesManager
        
        // Setup reactive subscriptions
        setupSubscriptions()
        
        // Load initial state
        updateHasFavorites()
    }
    
    /// Creates a favorites view model with production dependencies
    /// Call this in your views: @StateObject var viewModel = FavouritesViewModel.live()
    static func live() -> FavouritesViewModel {
        FavouritesViewModel(favouritesManager: .shared)
    }
    
    // MARK: - Public Methods
    
    /// Updates the favorites list with venue data
    /// - Parameter allVenues: All available venues from main screen
    ///
    /// Why Passed From Parent?
    /// - Avoids duplicate API calls (main screen already has data)
    /// - Favorites screen shows subset of main screen data
    /// - Memory efficient (reuse existing venue objects)
    ///
    /// Called when:
    /// - User navigates to favorites screen
    /// - Main screen fetches new venues
    
    func updateFavorites(from allVenues: [VenueItem]) {
        let favouriteIDs = favouritesManager.favouriteIDs
        // Filter venues to only include favorited ones
        favouritesVenues = allVenues.filter({ venue in
            favouriteIDs.contains(venue.id)
        })
    }
    
    /// Removes a venue from favorites
    /// - Parameter venueID: ID of the venue to remove
    ///
    /// Flow:
    /// 1. FavoritesManager removes ID
    /// 2. FavoritesManager publishes change
    /// 3. setupSubscriptions() receives change
    /// 4. favoriteVenues auto-updates
    /// 5. SwiftUI re-renders list
    func removeFavorite(venueID: String) {
        favouritesManager.removeFavourite(venueID: venueID)
    }
    
    /// Checks if a venue is favorited
    /// - Parameter venueID: ID of the venue to check
    /// - Returns: true if favorited, false otherwise
    func isFavorite(venueID: String) -> Bool {
        favouritesManager.isFavourite(venueID: venueID)
    }
    
    /// Clears all favorites
    /// Called when user taps "Clear All" button
    ///
    /// Shows confirmation dialog before clearing
    func clearFavourites() {
        favouritesManager.clearAllFavorites()
    }
    
    // MARK: - Private Helpers
    
    /// Sets up Combine subscriptions for reactive updates
    ///
    /// Subscription:
    /// - Favorites changes → Update local favoriteVenues array
    ///
    /// Why Needed?
    /// - When user unfavorites from main screen, favorites screen updates
    /// - When user removes from favorites screen, heart updates on main screen
    /// - Two-way sync between screens
    private func setupSubscriptions() {
        favouritesManager
            .$favouriteIDs
            .sink { [weak self] favouriteIDs in
                guard let self = self else { return }
                // Filter favoriteVenues to only include current favorites
                // Handles removal from other screens
                self.favouritesVenues = self.favouritesVenues.filter({ venue in
                    favouriteIDs.contains(venue.id)
                })
                self.updateHasFavorites()
            }
            .store(in: &cancellables)
    }
    
    /// Updates the hasFavorites flag
    /// Used to show/hide empty state view
    private func updateHasFavorites() {
        hasFavourites = !favouritesManager.favouriteIDs.isEmpty
    }
}

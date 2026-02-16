//
//  FavouritesManager.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//

import Foundation
import Combine

/// Protocol defining favorites management interface
/// Enables dependency injection and testing with mock implementations
///
/// Why Protocol?
/// - Testing: Can create MockFavoritesManager
/// - Flexibility: Could swap UserDefaults for Keychain/CloudKit later
/// - SOLID: Depend on abstractions


protocol FavouritesManagerProtocol: AnyObject {
    /// Current set of favorite venue IDs
    var favouriteIDs: Set<String> { get }
    
    /// Publisher that emits when favorites change
    var favouritesPublisher: AnyPublisher<Set<String>, Never> { get }
    
    /// Adds a venue to favorites
    func addFavourite(venueID: String)
    
    /// Removes a venue from favorites
    func removeFavourite(venueID: String)
    
    /// Checks if a venue is favorited
    func isFavourite(venueID: String) -> Bool
    
    /// Toggles favorite status for a venue
    func toggleFavorite(venueID: String)
    
    /// Removes all favorites
    func clearAllFavorites()
}

/// Manages user's favorite venues using UserDefaults for persistence
/// Observable object that publishes changes for reactive UI updates
///
/// Architecture Decisions:
/// - ObservableObject: SwiftUI views can observe changes
/// - @Published: Automatic UI updates when favorites change
/// - Set<String> internally: O(1) lookup for isFavorite()
/// - UserDefaults: Simple, persistent, no setup needed
///
/// Why Class not Struct?
/// - ObservableObject requires class (reference type)
/// - Shared state across app (singleton pattern)
/// - Mutable state (add/remove favorites)

final class FavouritesManager: ObservableObject, FavouritesManagerProtocol {

    /// Shared singleton instance
    /// Ensures all ViewModels use the same favorites data
    static let shared = FavouritesManager()

    /// Set of favorite venue IDs
    /// Published property automatically triggers UI updates
    ///
    /// Why Set instead of Array?
    /// - O(1) lookup: isFavorite() is instant
    /// - No duplicates: Can't favorite same venue twice
    /// - Unordered: We sort in ViewModel if needed
    @Published private(set) var favouriteIDs: Set<String> = []

    /// Publisher for favorites changes (for Combine subscribers)
    var favouritesPublisher: AnyPublisher<Set<String>, Never> {
        $favouriteIDs.eraseToAnyPublisher()
    }

    /// UserDefaults instance for persistence
    /// Injected for testability
    private let userDefaults: UserDefaults

    /// Key for storing favorites in UserDefaults
    /// Using Constants ensures consistency
    private let storageKey: String

    // MARK: - Initialization

    /// Initializes the favorites manager
    /// - Parameters:
    ///   - userDefaults: UserDefaults instance (defaults to standard)
    ///   - storageKey: Key for storing data (defaults to nil, uses Constants)
    ///
    /// Why Default Parameters?
    /// - Production: FavoritesManager() uses standard UserDefaults
    /// - Testing: FavoritesManager(userDefaults: mockDefaults)
    init(userDefaults: UserDefaults = .standard,
         storageKey: String? = nil) {
        self.userDefaults = userDefaults
        self.storageKey = storageKey ?? Constants.Storage.favoritesKey

        // Load saved favorites on initialization
        loadFavorites()
    }
    
    /// Adds a venue to favorites
    /// - Parameter venueID: Unique identifier of the venue
    ///
    /// Thread-safe: @Published handles main thread dispatch
    func addFavourite(venueID: String) {
        // Only add if not already favorited (Set handles this, but explicit is clear)
        guard !favouriteIDs.contains(venueID) else {
            return
        }
        favouriteIDs.insert(venueID)
        saveFavourites()
    }
    
    /// Removes a venue from favorites
    /// - Parameter venueID: Unique identifier of the venue
    func removeFavourite(venueID: String) {
        favouriteIDs.remove(venueID)
        saveFavourites()
    }
    
    /// Checks if a venue is in favorites
    /// - Parameter venueID: Unique identifier of the venue
    /// - Returns: True if venue is favorited, false otherwise
    ///
    /// Performance: O(1) lookup thanks to Set
    func isFavourite(venueID: String) -> Bool {
        favouriteIDs.contains(venueID)
    }
    
    /// Toggles favorite status for a venue
    /// - Parameter venueID: Unique identifier of the venue
    ///
    /// Convenience method for UI (heart button tap)
    func toggleFavorite(venueID: String) {
        if isFavourite(venueID: venueID) {
            removeFavourite(venueID: venueID)
        } else {
            addFavourite(venueID: venueID)
        }
    }
    
    /// Removes all favorites
    /// Useful for settings/preferences screen
    func clearAllFavorites() {
        favouriteIDs.removeAll()
        saveFavourites()
    }
    
    /// Loads favorites from UserDefaults
    ///
    /// Called on initialization to restore state
    private func loadFavorites() {
        // UserDefaults stores Array, convert to Set
        if let savedIDs = userDefaults.array(forKey: storageKey) as? [String] {
            favouriteIDs = Set(savedIDs)
        } else {
            favouriteIDs = []
        }
    }
    
    /// Saves favorites to UserDefaults
    ///
    /// Called after every modification (add/remove/clear)
    /// Why Convert Set → Array?
    /// - UserDefaults can't store Set directly
    /// - Array is JSON-serializable
    private func saveFavourites() {
        let idsArray = Array(favouriteIDs)
        userDefaults.set(idsArray, forKey: storageKey)
        
        // Force synchronize for immediate persistence (optional, but safer)
        // UserDefaults automatically syncs periodically, but this ensures immediate save
        userDefaults.synchronize()
    }
}

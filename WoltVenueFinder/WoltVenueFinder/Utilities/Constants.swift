//
//  Constants.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//
import SwiftUI

/// Central location for all app-wide constants
/// This makes the app easier to maintain and test
///
/// Usage:
/// ```swift
/// let url = Constants.API.baseURL
/// let padding = Constants.UI.standardPadding
/// let location = Constants.Location.helsinkiCoordinates[0]
/// ```


enum Constants {
    enum API {
        /// Base URL for Wolt's restaurant API
        /// This is the production endpoint - in real apps, we'd have dev/staging/prod URLs
        /// Using /front endpoint which returns venue listings in section 2 ("Popular right now")
        static let baseURL = "https://restaurant-api.wolt.com/v1/pages/front"
        
        /// Maximum number of venues to display per request
        /// As per requirements: "display up to 15 venues"
        static let maxVenuesToDisplay = 15
        
        /// API request timeout in seconds
        static let requestTimeout: TimeInterval = 30.0
        
        /// Number of retry attempts for failed requests
        static let maxRetryAttempts = 3
    }
    
    // MARK: - Location Simulation
    
    enum Location {
        /// Time interval between location updates (in seconds)
        /// As per requirements: "update every 10 seconds"
        static let updateInterval: TimeInterval = 10.0
        
        /// Predefined coordinates for simulating user movement around Helsinki
        /// These coordinates form a walking path through Helsinki city centre
        /// Path: Starting at Senate Square → Moving through downtown → Loop back
        static let helsinkiCoordinates: [(latitude: Double,
                                          longitude: Double)] = [
                                            (60.170187, 24.930599),  // Senate Square (starting point)
                                            (60.169418, 24.931618),  // Move southeast toward Market Square
                                            (60.169818, 24.932906),  // Continue southeast
                                            (60.170005, 24.935105),  // Move east along waterfront
                                            (60.169108, 24.936210),  // Move south into Kruununhaka
                                            (60.168355, 24.934869),  // Move west toward Esplanade
                                            (60.167560, 24.932562),  // Continue west through shopping district
                                            (60.168254, 24.931532),  // Move northwest toward train station
                                            (60.169012, 24.930341),  // Continue northwest
                                            (60.170085, 24.929569)   // Back to starting area (loop)
                                          ]
        
        /// Default location (Helsinki city center)
        static let defaultLocation = helsinkiCoordinates[0]
    }
    
    // MARK: - Persistence
    
    enum Storage {
        /// Key for storing favorite venue IDs in UserDefaults
        /// Using reverse domain notation to avoid conflicts with other apps
        static let favoritesKey = "com.wolt.venuefinder.favorites"
        
        /// UserDefaults suite name (for testing isolation)
        static let suiteName = "com.wolt.venuefinder"
    }
    // MARK: - UI Configuration
    
    /// Design system values matching your Google Stitch designs
    enum UI {
        
        // MARK: - Spacing & Layout
        
        /// Standard padding around content (16pt from design specs)
        static let standardPadding: CGFloat = 16
        
        /// Spacing between venue cards (12pt from design specs)
        static let cardSpacing: CGFloat = 12
        
        /// Spacing within card content (8pt from design specs)
        static let contentSpacing: CGFloat = 8
        
        /// Small spacing for tight layouts (4pt)
        static let smallSpacing: CGFloat = 4
        
        /// Large spacing for section separation (24pt)
        static let largeSpacing: CGFloat = 24
        
        // MARK: - Sizing
        
        /// Size of venue thumbnail images (72x72pt from design)
        static let thumbnailSize: CGFloat = 72
        
        /// Corner radius for venue images (8pt from design)
        static let imageCornerRadius: CGFloat = 8
        
        /// Corner radius for cards (12pt from design)
        static let cardCornerRadius: CGFloat = 12
        
        /// Corner radius for buttons (12pt from design)
        static let buttonCornerRadius: CGFloat = 12
        
        /// Size of heart icon (24pt from design)
        static let heartIconSize: CGFloat = 24
        
        /// Minimum tap target size (44pt - iOS HIG requirement)
        static let minTapTarget: CGFloat = 44
        
        /// Height of venue row (96pt from design)
        static let venueRowHeight: CGFloat = 96
        
        /// Height of primary buttons (50pt)
        static let buttonHeight: CGFloat = 50
        
        // MARK: - Animation Timing
        
        /// Duration for heart toggle animation
        static let heartAnimationDuration: Double = 0.3
        
        /// Spring animation response value (from design specs)
        static let springResponse: Double = 0.3
        
        /// Spring animation damping (from design specs)
        static let springDamping: Double = 0.7
        
        /// List fade transition duration
        static let listTransitionDuration: Double = 0.4
        
        /// Skeleton shimmer animation duration
        static let shimmerDuration: Double = 1.5
        
        // MARK: - Shadow
        
        /// Card shadow radius
        static let cardShadowRadius: CGFloat = 2
        
        /// Card shadow opacity
        static let cardShadowOpacity: Double = 0.05
        
        /// Card shadow offset
        static let cardShadowOffset = CGSize(width: 0, height: 1)
    }
    
    // MARK: - Accessibility
    
    enum Accessibility {
        /// VoiceOver label for unfavorited venue
        static let favoriteAction = "Double tap to add to favorites"
        
        /// VoiceOver label for favorited venue
        static let unfavoriteAction = "Double tap to remove from favorites"
        
        /// VoiceOver label for retry button
        static let retryAction = "Double tap to retry loading venues"
        
        /// VoiceOver label for refresh action
        static let refreshAction = "Double tap to refresh venue list"
        
        /// Minimum font scale for dynamic type
        static let minimumScaleFactor: CGFloat = 0.8
    }
    
   
}


extension Constants {
    // MARK: - App Info
    enum App {
        /// App name
        static let name = "WoltVenueFinder"
        
        /// App version (should match Info.plist)
        static let version = "1.0.0"
        
        /// Build number
        static let build = "1"
        
        /// Support email
        static let supportEmail = "mdsadidurrahman74@gmail.com"
        
        /// GitHub repository URL
        static let githubURL = "https://github.com/shaikat1993/WoltVenueFinder"
    }
}

extension Constants {
    // MARK: - Error Messages
    
    enum ErrorMessages {
        /// Network error message
        static let networkError = "Unable to load venues. Please check your internet connection."
        
        /// Generic error message
        static let genericError = "Something went wrong. Please try again."
        
        /// No venues found message
        static let noVenues = "No venues found in this area."
        
        /// Timeout error message
        static let timeoutError = "Request timed out. Please try again."
        
        /// Server error message
        static let serverError = "Server error. Please try again later."
    }
    
    // MARK: - Empty State Messages
    
    enum EmptyState {
        /// No favorites title
        static let noFavoritesTitle = "No Favorites Yet"
        
        /// No favorites message
        static let noFavoritesMessage = "Tap the heart icon on any venue to save it to your favorites"
        
        /// No favorites button text
        static let noFavoritesButton = "Explore Venues"
    }
}

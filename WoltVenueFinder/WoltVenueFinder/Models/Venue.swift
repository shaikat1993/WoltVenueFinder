//
//  Venue.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//

import Foundation

/// Represents a single restaurant/venue from the Wolt API
/// This is the core business model containing venue details
///
/// Example JSON:
/// ```json
/// {
///   "id": "60e2a5e7-b123-4567-8901-abcdef123456",
///   "name": "The Blue Olive",
///   "short_description": "Fresh Mediterranean dishes"
/// }
/// ```

struct Venue: Codable,
              Identifiable,
              Equatable {
    /// Unique identifier for the venue
    /// Used by SwiftUI List to track items efficiently
    let id: String
    
    /// Display name of the venue
    /// Example: "The Blue Olive", "Sunrise Brew"
    let name: String
    
    /// Short tagline or cuisine type
    /// Example: "Fresh Mediterranean", "Coffee & Pastries"
    let shortDescription: String
    
    /// Maps Swift property names to JSON keys
    /// Handles snake_case from API → camelCase in Swift
    ///
    /// Why needed:
    /// - API returns "short_description" (snake_case)
    /// - Swift convention is "shortDescription" (camelCase)
    /// - CodingKeys bridges the gap
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortDescription = "short_description" // <- key mapping
    }
}

// MARK: - Preview Data

#if DEBUG
extension Venue {
    /// Single sample venue for SwiftUI previews
    static let preview = Venue(
        id: "preview-1",
        name: "The Blue Olive",
        shortDescription: "Fresh Mediterranean"
    )
    
    /// Array of sample venues for list previews
    static let previewArray: [Venue] = [
        Venue(id: "1",
              name: "McDonald's Helsinki Kamppi",
              shortDescription: "I'm lovin' it."),
        Venue(id: "2",
              name: "Noodle Story Freda",
              shortDescription: "Asian street food"),
        Venue(id: "3",
              name: "Putte's Bar & Pizza",
              shortDescription: "Pizza & burgers"),
        Venue(id: "4",
              name: "The Blue Olive",
              shortDescription: "Fresh Mediterranean"),
        Venue(id: "5",
              name: "Sushi Palace",
              shortDescription: "Premium Japanese cuisine"),
        Venue(id: "6",
              name: "Café Central",
              shortDescription: "Coffee & pastries"),
        Venue(id: "7",
              name: "Green Bowl",
              shortDescription: "Healthy vegetarian options"),
        Venue(id: "8",
              name: "Thai Street Kitchen",
              shortDescription: "Authentic Thai flavors"),
        Venue(id: "9",
              name: "Burger Kingdom",
              shortDescription: "Gourmet burgers"),
        Venue(id: "10",
              name: "Pasta Paradise",
              shortDescription: "Homemade Italian pasta")
    ]
}
#endif

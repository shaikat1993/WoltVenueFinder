//
//  VenueItem.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//

import Foundation

/// Represents a section in the API response
/// The Wolt API uses sections to group different types of content
/// For our use case, we only care about the first section which contains venues
///
/// API JSON looks like:
/// ```json
/// {
///   "items": [
///     { "venue": {...}, "image": {...} },
///     { "venue": {...}, "image": {...} }
///   ]
/// }
/// ```
struct Section: Codable, Equatable {

    /// Array of venue items in this section
    let items: [VenueItem]

    /// Section title (optional - only decode if present)
    let title: String?

    /// We only care about items, ignore other fields
    /// Codable will ignore fields not defined here
    
    // MARK: - Computed Properties
    /// Check if this section has any items
    var hasItems: Bool {
        !items.isEmpty
    }
    
    /// number of items in this section
    var count: Int {
        items.count
    }
    
    /// Returns items limited to a specific count
    /// Used to enforce "display up to 15 venues" requirement
    func limitedItems(to limit: Int) -> [VenueItem] {
        Array(items.prefix(limit))
    }
}

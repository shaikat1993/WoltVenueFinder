//
//  VenueResponse.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//
import Foundation
/// Represents the complete API response from Wolt's restaurant endpoint
/// This is the root object that JSONDecoder will decode
///
/// Complete API JSON structure:
/// ```json
/// {
///   "sections": [
///     {
///       "items": [
///         {
///           "venue": {
///             "id": "5ae6013cf78b5a000bb64022",
///             "name": "McDonald's Helsinki Kamppi",
///             "short_description": "I'm lovin' it."
///           },
///           "image": {
///             "url": "https://imageproxy.wolt.com/..."
///           }
///         }
///       ]
///     }
///   ]
/// }
/// ```

struct VenueResponse: Codable,
                      Equatable {
    /// Array of sections (we only use the first one)
    let sections: [Section]
    
    /// Extracts venue items from section 2 ("Popular right now")
    /// The Wolt /front API returns venues in sections[2].items
    /// Section 0: Banners, Section 1: Categories, Section 2: Popular venues
    /// Filters out items without valid venue data
    var venueItems: [VenueItem] {
        guard sections.count > 2 else { return [] }
        return sections[2].items.filter { $0.hasVenue }
    }
    
    /// Returns venue items limited to the specified count
    /// Default limit is 15 as per requirements
    func limitedVenueItems(to limit: Int = Constants.API.maxVenuesToDisplay) -> [VenueItem] {
        Array(venueItems.prefix(limit))
    }
    /// Check if the response contains any venues
    var hasVenues: Bool {
        !venueItems.isEmpty
    }
    
    /// Total number of venues in the response
    var venueCount: Int {
        venueItems.count
    }
}

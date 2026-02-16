//
//  VenueItem.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//
import Foundation
/// Represents a single item in the API's items array
/// Each item combines venue details with its image
///
/// API JSON looks like:
/// ```json
/// {
///   "venue": {
///     "id": "5ae6013cf78b5a000bb64022",
///     "name": "McDonald's Helsinki Kamppi",
///     "short_description": "I'm lovin' it."
///   },
///   "image": {
///     "url": "https://imageproxy.wolt.com/..."
///   }
/// }
/// ```

struct VenueItem: Codable, Identifiable, Equatable {
    /// The restaurant/venue details (optional - some items don't have venues)
    let venue: Venue?

    /// The venue's thumbnail image (optional - some items don't have images)
    let image: VenueImage?

    // MARK: - Identifiable Conformance

    /// Delegates to the venue's ID for SwiftUI List tracking
    /// Returns empty string if no venue (filtered out later)
    var id: String {
        venue?.id ?? ""
    }

    // MARK: - Computed Properties

    /// Check if this item has valid venue data
    var hasVenue: Bool {
        venue != nil && image != nil
    }

    // MARK: - Convenience Properties
    /// Quick access to venue name without typing `venueItem.venue.name`
    var name: String {
        venue?.name ?? ""
    }

    /// Quick access to description without nesting
    var shortDescription: String {
        venue?.shortDescription ?? ""
    }

    /// Quick access to image URL without nesting
    var imageURL: String {
        image?.url ?? ""
    }

    /// Check if this item has a valid image
    var hasValidImage: Bool {
        image?.isValid ?? false
    }
}

// MARK: - Preview Data

#if DEBUG
extension VenueItem {
    /// Single sample item for SwiftUI previews
    static let preview = VenueItem(
        venue: .preview,
        image: .preview
    )
    
    /// Array of sample items for list previews
    static let previewArray: [VenueItem] = Venue.previewArray.map { venue in
        VenueItem(
            venue: venue,
            image: VenueImage(url: "https://imageproxy.wolt.com/assets/sample-\(venue.id)")
        )
    }
}
#endif

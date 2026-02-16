//
//  VenueRow.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//

import SwiftUI

/// Reusable venue card component
/// Displays venue thumbnail, name, description, and favorite button
///
/// Used in:
/// - VenueListView (main screen)
/// - FavoritesView (favorites screen)
///
/// Why Separate Component?
/// - Reusability (DRY principle)
/// - Consistent design across screens
/// - Easy to modify (change once, updates everywhere)
/// - Testable in isolation with previews
struct VenueRow: View {
    /// The venue item to display
    let venue: VenueItem
    
    /// Whether this venue is favorited
    let isFavourite: Bool
    
    /// Callback when favorite button is tapped
    let onFavouriteBtnTap: () -> Void
    
    
    var body: some View {
        HStack(spacing: Constants.UI.standardPadding) {
            // Venue thumbnail image
            venueImage
            
            //Venue details (name + description)
            venueDetails
            
            Spacer()
            
            // Favorite button (heart icon)
            favouriteButton
        }
        .padding(Constants.UI.standardPadding)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(
            color: Color.black.opacity(Constants.UI.cardShadowOpacity),
            radius: Constants.UI.cardShadowRadius,
            x: 0,
            y: 10
        )
    }
    
    // MARK: - Subviews
    /// Venue thumbnail image with async loading
    private var venueImage: some View {
        AsyncImage(url: URL(string: venue.imageURL)) { state in
            switch state {
            case .empty:
                // Loading placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.woltBlue.opacity(0.1))
                    .frame(
                        width: Constants.UI.thumbnailSize,
                        height: Constants.UI.thumbnailSize)
                    .overlay {
                        ProgressView()
                            .tint(.woltBlue)
                    }
            case .success(let image):
                // Successfully loaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: Constants.UI.thumbnailSize,
                        height: Constants.UI.thumbnailSize
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .failure(_):
                // Failed to load - show placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.woltBlue.opacity(0.1))
                    .frame(
                        width: Constants.UI.thumbnailSize,
                        height: Constants.UI.thumbnailSize
                    )
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.woltBlue.opacity(0.5))
                    )
            @unknown default:
                EmptyView()
            }
        }
    }
    
    /// Venue name and description stack
    private var venueDetails: some View {
        VStack(alignment: .leading,
               spacing: 4) {
            // venue name
            Text(venue.name)
                .font(.venueName)
                .foregroundColor(.textPrimary)
                .lineLimit(2)
            
            //venue description
            Text(venue.shortDescription)
                .font(.subtitle)
                .foregroundColor(.textSecondary)
                .lineLimit(1)
        }
    }
    
    /// Favorite button with heart icon
    private var favouriteButton: some View {
        Button(action: {
            // haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            //call callback
            onFavouriteBtnTap()
        }) {
            Image(systemName: isFavourite ?
                  "heart.fill" : "heart")
            .font(.system(size: Constants.UI.heartIconSize))
            .foregroundColor(isFavourite ?
                .heartActive : .heartInactive)
            .frame(width: 44, height: 44) // Larger tap target (44x44 is iOS standard)
        }
        .buttonStyle(.plain)
        //accessibility
        .accessibilityLabel(isFavourite ?
                            "Remove from favorites" : "Add to favorites")
        // Animation
        .animation(
            .spring(
                response: Constants.UI.springResponse,
                dampingFraction: Constants.UI.springDamping
            ),
            value: isFavourite
        )
        
    }
}

// MARK: - Previews

#Preview("Single Venue") {
    VenueRow(
        venue: .preview,
        isFavourite: false,
        onFavouriteBtnTap: { print("Favourite tapped") }
    )
    .padding()
}

#Preview("Favourited Venue") {
    VenueRow(
        venue: .preview,
        isFavourite: true,
        onFavouriteBtnTap: { print("Favourite tapped") }
    )
    .padding()
}

#Preview("Long Name") {
    VenueRow(
        venue: VenueItem(
            venue: Venue(
                id: "1",
                name: "McDonald's Helsinki Kamppi Central Station Restaurant",
                shortDescription: "I'm lovin' it."
            ),
            image: .preview
        ),
        isFavourite: false,
        onFavouriteBtnTap: {}
    )
    .padding()
}

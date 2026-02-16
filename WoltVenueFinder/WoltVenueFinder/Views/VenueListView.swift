//
//  VenueListView.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//

import SwiftUI
/// Main venue list screen
/// Shows nearby restaurants based on simulated location
///
/// Features:
/// - Auto-refreshing list (updates every 10s with new location)
/// - Pull-to-refresh
/// - Loading skeleton
/// - Error handling with retry
/// - Favorites integration
/// - Navigation to favorites screen
struct VenueListView: View {
    /// ViewModel managing venue list state
    @StateObject private var viewModel = VenueListViewModel.live()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                
                // Content based on state
                content
            }
            .navigationTitle("Nearby Restaurants")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    favoritesButton
                }
            }
            .onAppear {
                handleViewAppear()
            }
            .onDisappear {
                viewModel.stopLocationUpdates()
            }
        }
    }

    /// Main content - switches between loading/error/success states
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading &&
            viewModel.venues.isEmpty {
            // Loading state (first load)
            LoadingView()
        } else if let errorMessage = viewModel.errorMessage,
                    viewModel.venues.isEmpty {
            // Error state (only if no venues loaded yet)
            ErrorView(message: errorMessage) {
                viewModel.retry()
            }
        } else {
            // Success state (has venues)
            venueList
        }
    }
    
    /// Scrollable list of venues
    private var venueList: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Location indicator
                locationHeader

                // Error banner (shown above list if error occurred)
                if let errorMessage = viewModel.errorMessage {
                    errorBanner(message: errorMessage)
                }
                // Venue list
                LazyVStack(spacing: Constants.UI.standardPadding) {
                    ForEach(viewModel.venues) { venue in
                        VenueRow(
                            venue: venue,
                            isFavourite: viewModel.favoriteIDs.contains(venue.id),
                            onFavouriteBtnTap: {
                                viewModel.toggleFavourite(venueID: venue.id)
                            }
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    }
                }
                .padding(Constants.UI.standardPadding)
                .animation(.spring(), value: viewModel.venues)
            }
        }
        .refreshable {
            await viewModel.fetchVenues()
        }
    }
    /// Location indicator showing current simulated location
    private var locationHeader: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.woltBlue)
                .font(.caption)

            Text(locationName)
                .font(.caption)
                .foregroundColor(.textSecondary)

            Spacer()

            // Refresh indicator
            if viewModel.isLoading {
                HStack(spacing: 4) {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text(viewModel.venues.isEmpty ? "Loading..." : "Refreshing...")
                        .font(.caption2)
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(.horizontal, Constants.UI.standardPadding)
        .padding(.vertical, 8)
        .background(Color.woltBlue.opacity(0.05))
    }
    
    /// Error banner shown when fetch fails but we have cached venues
    private func errorBanner(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Button("Retry") {
                viewModel.retry()
            }
            .font(.caption.bold())
            .foregroundColor(.woltBlue)
        }
        .padding(Constants.UI.standardPadding)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal, Constants.UI.standardPadding)
        .padding(.top, 8)
    }
    
    /// Favorites button in navigation bar
    private var favoritesButton: some View {
        NavigationLink(destination: FavoritesView(allVenues: viewModel.venues)) {
            Image(systemName: "heart.fill")
                .foregroundColor(.heartActive)
        }
    }
    
    // MARK: - Helpers
    
    /// Handles view appear lifecycle
    private func handleViewAppear() {
        // Start location simulation
        viewModel.startLocationUpdates()
        
        // Initial fetch if needed
        if viewModel.venues.isEmpty {
            Task {
                await viewModel.fetchVenues()
            }
        }
    }
    
    /// Converts coordinates to location name
    /// Maps coordinates to known Helsinki landmarks
    /// Matches exactly with Constants.Location.helsinkiCoordinates
    private var locationName: String {
        let coords = viewModel.currentLocation

        // Match against the actual simulation path from Constants
        // These coordinates match Constants.Location.helsinkiCoordinates exactly
        let locations: [(coords: (Double, Double), name: String)] = [
            ((60.170187, 24.930599), "Senate Square"),           // 0: Starting point
            ((60.169418, 24.931618), "Market Square"),           // 1: Southeast
            ((60.169818, 24.932906), "Esplanade Park"),          // 2: Continue SE
            ((60.170005, 24.935105), "Katajanokka Waterfront"),  // 3: East waterfront
            ((60.169108, 24.936210), "Kruununhaka"),             // 4: South
            ((60.168355, 24.934869), "Esplanade Shopping"),      // 5: West to Esplanade
            ((60.167560, 24.932562), "Shopping District"),       // 6: Continue west
            ((60.168254, 24.931532), "Central Station Area"),    // 7: NW to station
            ((60.169012, 24.930341), "Kamppi Center"),           // 8: Continue NW
            ((60.170085, 24.929569), "Senate Square Loop")       // 9: Back to start
        ]

        // Find exact match (coordinates match within 0.0001 tolerance)
        if let match = locations.first(where: { location in
            abs(location.coords.0 - coords.latitude) < 0.0001 &&
            abs(location.coords.1 - coords.longitude) < 0.0001
        }) {
            return match.name
        }

        return "Helsinki City Center"
    }
}

#Preview("Real API Call") {
    VenueListView()
}

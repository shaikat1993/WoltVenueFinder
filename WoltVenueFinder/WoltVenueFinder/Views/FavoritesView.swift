//
//  FavoritesView.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//
import SwiftUI
/// Favorites screen showing user's saved venues
///
/// Features:
/// - List of favorited venues
/// - Remove from favorites (swipe or tap heart)
/// - Clear all favorites button
/// - Empty state when no favorites
/// - Auto-updates when favorites change

struct FavoritesView: View {
    /// ViewModel managing favorites state
    @StateObject private var viewModel = FavouritesViewModel.live()
    
    /// All venues from parent view (to get full venue data)
    let allVenues: [VenueItem]
    
    /// Confirmation dialog state
    @State private var showingClearConfirmation = false
    
    var body: some View{
        ZStack{
            //background
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            // Content based on state
            content
        }
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                clearAllButton
            }
        }
        .onAppear {
            viewModel.updateFavorites(from: allVenues)
        }
        .confirmationDialog(
            "Clear All Favorites?",
            isPresented: $showingClearConfirmation,
            titleVisibility: .visible) {
                Button("Clear All",
                       role: .destructive){
                    viewModel.clearFavourites()
                }
                Button("Cancel",
                       role: .cancel) {}
            } message: {
                Text("This will remove all venues from your favorites.")
            }
    }
    
    // MARK: - Subviews
    /// Main content - switches between empty/filled states
    @ViewBuilder
    private var content: some View {
        if viewModel.hasFavourites {
            favouritesList
        } else {
            EmptyStateView()
        }
    }
    
    /// List of favorite venues
    private var favouritesList: some View {
        ScrollView{
            LazyVStack(spacing: Constants.UI.standardPadding) {
                ForEach(viewModel.favouritesVenues) { venue in
                    VenueRow(venue: venue,
                             isFavourite: true,
                             onFavouriteBtnTap: {
                        withAnimation {
                            viewModel.removeFavorite(venueID: venue.id)
                        }
                    })
                    .transition(.asymmetric(insertion: .scale
                        .combined(with: .opacity),
                                            removal: .move(edge: .trailing)
                        .combined(with: .opacity)))
                    .swipeActions(edge: .trailing,
                                  allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.removeFavorite(venueID: venue.id)
                            }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(Constants.UI.standardPadding)
            .animation(.spring(), value: viewModel.favouritesVenues)
        }
    }
    
    /// Clear all button in toolbar
    private var clearAllButton: some View {
        Button(action: {
            showingClearConfirmation = true
        }) {
            Text("Clear All")
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .disabled(!viewModel.hasFavourites)
    }
}



// MARK: - Previews

#Preview("With Favorites") {
    NavigationView {
        FavoritesView(allVenues: VenueItem.previewArray)
    }
}

#Preview("Empty State") {
    NavigationView {
        FavoritesView(allVenues: [])
    }
}

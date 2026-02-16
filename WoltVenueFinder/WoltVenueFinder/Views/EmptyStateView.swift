//
//  EmptyStateView.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//

import SwiftUI
/// Empty state view for favorites screen
/// Shown when user has no favorites yet
///
/// UX Principles:
/// - Explain why it's empty
/// - Show how to fix it (tap heart icon)
/// - Friendly, encouraging tone
/// - Visual icon for quick understanding

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            //heart icon
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.heartInactive)
            
            //title
            Text(Constants.EmptyState.noFavoritesTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            // Message
            Text(Constants.EmptyState.noFavoritesMessage)
                .font(.bodyText)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}
// MARK: - Preview

#Preview {
    EmptyStateView()
}

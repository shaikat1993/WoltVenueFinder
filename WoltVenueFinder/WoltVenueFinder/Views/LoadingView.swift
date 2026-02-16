//
//  LoadingView.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//
import SwiftUI
/// Loading skeleton view shown while fetching venues
/// Uses shimmer effect for better UX
///
/// Why Skeleton Loading?
/// - Better perceived performance (feels faster)
/// - Shows structure of upcoming content
/// - More engaging than spinner
/// - Industry standard (Facebook, LinkedIn use this)
struct LoadingView: View {
    var body: some View {
        VStack(spacing: Constants.UI.standardPadding) {
            ForEach(0..<5, id: \.self) { _ in
                skeletonRow
            }
        }
        .padding(Constants.UI.standardPadding)
    }
    
    // MARK: - Subviews
    
    /// Single skeleton row mimicking VenueRow layout
    private var skeletonRow: some View {
        HStack(spacing: Constants.UI.standardPadding) {
            // Image skeleton
            RoundedRectangle(cornerRadius: Constants.UI.imageCornerRadius)
                .fill(Color.gray.opacity(0.3))
                .frame(
                    width: Constants.UI.thumbnailSize,
                    height: Constants.UI.thumbnailSize
                )
            
            // Text skeletons
            VStack(alignment: .leading, spacing: Constants.UI.contentSpacing) {
                // Name skeleton (wider)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                
                // Description skeleton (narrower)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .frame(maxWidth: 200)
            }
            
            // Heart icon skeleton
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(
                    width: Constants.UI.heartIconSize,
                    height: Constants.UI.heartIconSize
                )
        }
        .padding(Constants.UI.standardPadding)
        .background(Color.cardBackground)
        .cornerRadius(Constants.UI.cardCornerRadius)
        .shadow(
            color: Color.black.opacity(Constants.UI.cardShadowOpacity),
            radius: Constants.UI.cardShadowRadius,
            x: 0,
            y: 10
        )
        // Use shimmer from View+Extension
        .shimmering(active: true)
    }
}

#Preview {
    LoadingView()
}

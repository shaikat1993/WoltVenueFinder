//
//  ErrorView.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 16.2.2026.
//
import SwiftUI
/// Error state view with retry button
/// Shown when venue fetch fails
///
/// Design:
/// - Large icon for visual hierarchy
/// - Clear error message
/// - Prominent retry button
/// - Friendly, not alarming
struct ErrorView: View {
    /// Error message to display
    let message: String
    
    //callback when retry button is tapped
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            //Error icon
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.woltBlue)
            
            // Error message
            VStack(spacing: 8) {
                Text("Oops!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(message)
                    .font(.bodyText)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            // Retry button
            Button(action: onRetry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.woltBlue)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: - Preview

#Preview {
    ErrorView(
        message: "Unable to load venues. Please check your internet connection.",
        onRetry: { print("Retry tapped") }
    )
}

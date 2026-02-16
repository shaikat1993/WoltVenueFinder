//
//  View+Extension.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//

// Reusable View modifiers and utilities
import SwiftUI

//MARK: View Extensions

extension View {
    //conditional modifiers
    /// Apply a modifier conditionally
    /// - Parameters:
    ///   - condition: Boolean condition
    ///   - transform: Closure that applies the modifier
    /// - Returns: Modified view if condition is true, original view otherwise
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .if(isHighlighted) { view in
    ///         view.foregroundColor(.red)
    ///     }
    /// ```
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Apply different modifiers based on condition
    /// - Parameters:
    ///   - condition: Boolean condition
    ///   - ifTransform: Closure applied when true
    ///   - elseTransform: Closure applied when false
    /// - Returns: Conditionally modified view
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .if(isDarkMode,
    ///         then: { $0.foregroundColor(.white) },
    ///         else: { $0.foregroundColor(.black) }
    ///     )
    /// ```
    
    @ViewBuilder
    func `if`<TrueContent: View,
              FalseContent: View>(_ condition: Bool,
                                  then ifTransform: (Self) -> TrueContent,
                                  else elseTransform: (Self) -> FalseContent) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    
    // MARK: - Card Style
    
    /// Apply standard card styling matching the design system
    /// - Parameters:
    ///   - cornerRadius: Corner radius (default: 12pt from design specs)
    ///   - padding: Internal padding (default: 16pt)
    ///   - shadowRadius: Shadow blur radius (default: 2pt)
    ///   - shadowOpacity: Shadow opacity (default: 0.05 for subtle depth)
    /// - Returns: View with card styling
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     Text("Card Content")
    /// }
    /// .cardStyle()
    /// ```
    func cardStyle(cornerRadius: CGFloat = Constants.UI.cardCornerRadius,
                   padding: CGFloat = Constants.UI.standardPadding,
                   ShadowRadius: CGFloat = 2,
                   shadowOpacity: CGFloat = 0.05) -> some View{
        self.padding(padding)
            .background(Color.cardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(shadowOpacity),
                    radius: ShadowRadius,
                    x: 0,
                    y: 1)
    }
    
    // MARK: - Skeleton Loading
    
    /// Apply skeleton loading effect (shimmer)
    /// - Parameter isLoading: Whether to show skeleton effect
    /// - Returns: View with skeleton effect when loading
    ///
    /// Example:
    /// ```swift
    /// Text("Loading...")
    ///     .skeleton(isLoading: viewModel.isLoading)
    /// ```
    func skeleton(isLoading: Bool) -> some View {
        self.redacted(reason: isLoading ? .placeholder : [])
            .shimmering(active: isLoading)
    }
    
    // MARK: - Shimmer Effect (Private Helper)
    /// Apply shimmer animation effect
    /// - Parameter active: Whether shimmer is active
    /// - Returns: View with shimmer animation
    ///
    /// Note: This is a private helper. Use .skeleton() instead.
     func shimmering(active: Bool) -> some View {
        self.modifier(ShimmerModifier(isActive: active))
    }
    
    // MARK: - Corner Radius (Selective Corners)
    
    /// Apply corner radius to specific corners
    /// - Parameters:
    ///   - radius: Corner radius value
    ///   - corners: Which corners to round
    /// - Returns: View with selective corner rounding
    ///
    /// Example:
    /// ```swift
    /// Rectangle()
    ///     .cornerRadius(20, corners: [.topLeft, .topRight])
    /// ```
    func cornerRadius(_ radius: CGFloat,
                      corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius,
                                corners: corners))
    }
}

// MARK: - Shimmer Modifier

/// ViewModifier that creates a shimmer/loading effect
/// Used internally by .skeleton() modifier
private struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    if isActive {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                Color.white.opacity(0.3),
                                .clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * 2)
                        .offset(x: phase * geometry.size.width * 2 - geometry.size.width * 2)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: phase
                        )
                        .onAppear {
                            phase = 1
                        }
                    }
                }
            )
    }
}

// MARK: - Rounded Corner Shape

/// Custom shape for selective corner rounding
private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

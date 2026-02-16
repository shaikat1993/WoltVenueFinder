//
//  ColorExtension.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//

import SwiftUI
// color extension with Hex Support
extension Color{
    //MARK: Hex initializer
    
    /// Initialize Color from hex string
    /// - Parameter hex: Hex string (e.g., "#00A8E8", "00A8E8", "0A8")
    /// - Returns: Color instance
    ///
    /// Supports formats:
    /// - 3 characters: RGB (e.g., "F0A" = "#FF00AA")
    /// - 6 characters: RRGGBB (e.g., "00A8E8")
    /// - 8 characters: AARRGGBB (e.g., "FF00A8E8" with alpha)
    ///
    /// Example:
    /// ```swift
    /// let blue = Color(hex: "#00A8E8")
    /// let red = Color(hex: "FF0000")
    /// let transparentGreen = Color(hex: "8000FF00") // 50% alpha
    /// ```
    
    init(hex: String) {
        // Remove any non-alphanumeric characters (handles "#", spaces, etc.)
        let hex = hex.trimmingCharacters(in: CharacterSet
                                            .alphanumerics
                                            .inverted)
        // Convert hex string to integer
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        // Extract color components based on format
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit) - e.g., "F0A"
            // Each character represents 4 bits, multiply by 17 to get 8-bit value
            // Example: F (15) * 17 = 255, 0 * 17 = 0, A (10) * 17 = 170
            (a, r, g, b) = (
                255,                          // Full opacity
                (int >> 8) * 17,              // Red: first char
                (int >> 4 & 0xF) * 17,        // Green: second char
                (int & 0xF) * 17              // Blue: third char
            )
            
        case 6: // RGB (24-bit) - e.g., "00A8E8"
            (a, r, g, b) = (
                255,                   // Full opacity
                int >> 16,             // Red: first 2 chars
                int >> 8 & 0xFF,       // Green: middle 2 chars
                int & 0xFF             // Blue: last 2 chars
            )
            
        case 8: // ARGB (32-bit) - e.g., "FF00A8E8"
            (a, r, g, b) = (
                int >> 24,             // Alpha: first 2 chars
                int >> 16 & 0xFF,      // Red
                int >> 8 & 0xFF,       // Green
                int & 0xFF             // Blue
            )
            
        default:
            // Invalid format - default to transparent black
            (a, r, g, b) = (255, 0, 0, 0)
        }
        // Initialize Color with normalized values (0.0 - 1.0)
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    // MARK: - Brand Colors
    
    /// Wolt's primary brand color (#00A8E8)
    /// Used for: Primary buttons, active states, brand elements
    static let woltBlue = Color(hex: "00A8E8")
    
    // MARK: - Semantic Colors (UI States)
    
    /// Active favorite/heart color (#E5006E)
    /// Used for: Filled heart icon, favorited state
    static let heartActive = Color(hex: "E5006E")
    
    /// Inactive favorite/heart color (#D1D1D6)
    /// Used for: Outline heart icon, non-favorited state
    static let heartInactive = Color(hex: "D1D1D6")
    
    // MARK: - Text Colors
    
    /// Primary text color (black)
    /// Used for: Venue names, headings, primary content
    static let textPrimary = Color.black
    
    /// Secondary text color (#8E8E93)
    /// Used for: Descriptions, subtitles, metadata
    static let textSecondary = Color(hex: "8E8E93")
    
    // MARK: - Background Colors
    
    /// Card background color (#FAFAFA)
    /// Used for: Venue cards, elevated surfaces
    static let cardBackground = Color(hex: "FAFAFA")
    
    /// Main app background (system background with fallback)
    static let appBackground = Color(uiColor: .systemBackground)
    
    // MARK: - Helper Methods
    /// Convert Color to hex string
    /// Note: This is a simplified version, full implementation would require UIColor conversion
    /// - Returns: Hex string representation (e.g., "#00A8E8")
    
    func toHex(includeAlpha: Bool = false) -> String? {
        // Convert SwiftUI Color to UIColor
        // Note: This requires converting through UIColor's RGB space
        guard let components = UIColor(self).cgColor.components else {
            return nil
        }
        
        // CGColor components are in 0.0-1.0 range
        // We need to convert to 0-255 range for hex
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        // Alpha component (defaults to 1.0 if not present)
        let a = components.count >= 4 ? components[3] : 1.0
        
        if includeAlpha {
            // Format: #AARRGGBB
            return String(
                format: "#%02X%02X%02X%02X",
                Int(a * 255),
                Int(r * 255),
                Int(g * 255),
                Int(b * 255)
            )
        } else {
            // Format: #RRGGBB
            return String(
                format: "#%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255)
            )
        }
    }
}

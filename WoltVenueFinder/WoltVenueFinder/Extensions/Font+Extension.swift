//
//  Font+Extensions.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//

//  Typography system matching design specifications

import SwiftUI
// MARK: - Font Extensions

extension Font {
    
    // MARK: - App Typography Scale
    
    /// Large navigation title font (34pt Bold)
    /// Used for: Main navigation bar titles
    static let largeTitle = Font.system(size: 34,
                                        weight: .bold,
                                        design: .default)
    
    /// Venue name font (17pt Semibold)
    /// Used for: Restaurant names in list
    static let venueName = Font.system(size: 17,
                                       weight: .semibold,
                                       design: .default)
    
    /// Body text / description font (15pt Regular)
    /// Used for: Venue descriptions, body content
    static let bodyText = Font.system(size: 15,
                                      weight: .regular,
                                      design: .default)
    
    /// Small subtitle font (13pt Regular)
    /// Used for: Metadata, secondary information, timestamps
    static let subtitle = Font.system(size: 13,
                                      weight: .regular,
                                      design: .default)
    
    /// Caption font (11pt Regular)
    /// Used for: Fine print, disclaimers
    static let caption = Font.system(size: 11,
                                     weight: .regular,
                                     design: .default)
    
    // MARK: - Semantic Fonts
    
    /// Button text font (17pt Semibold)
    /// Used for: Primary and secondary buttons
    static let buttonText = Font.system(size: 17,
                                        weight: .semibold,
                                        design: .default)
    
    /// Error message font (15pt Regular)
    /// Used for: Error descriptions
    static let errorText = Font.system(size: 15,
                                       weight: .regular,
                                       design: .default)
    
    /// Empty state title font (20pt Semibold)
    /// Used for: Empty state screen titles
    static let emptyStateTitle = Font.system(size: 20,
                                             weight: .semibold,
                                             design: .default)
}

// MARK: - Text Style Helper
extension Text {
    /// Apply venue name styling
    /// - Returns: Styled text for venue names
    func venueNameStyle() -> Text {
        self.font(.venueName)
            .foregroundColor(.textPrimary)
    }
    
    /// Apply description styling
    /// - Returns: Styled text for descriptions
    func descriptionStyle() -> Text {
        self.font(.bodyText)
            .foregroundColor(.textSecondary)
    }
    
    /// Apply subtitle styling
    /// - Returns: Styled text for subtitles
    func subtitleStyle() -> Text {
        self.font(.subtitle)
            .foregroundColor(.textSecondary)
    }
}

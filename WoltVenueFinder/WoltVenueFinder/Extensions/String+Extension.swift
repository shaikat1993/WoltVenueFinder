//
//  String+Extensions.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//

import Foundation
import UIKit

// MARK: - String Extensions

extension String {
    // MARK: - Validation
    
    /// Check if string is a valid URL
    var isValidURL: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    /// Check if string is not empty (contains non-whitespace characters)
    var isNotEmpty: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Truncation
    
    /// Truncate string to specified length with ellipsis
    /// - Parameters:
    ///   - length: Maximum length before truncation
    ///   - trailing: Trailing string to append (default: "...")
    /// - Returns: Truncated string
    ///
    /// Example:
    /// ```swift
    /// "Hello World".truncated(to: 5) // "Hello..."
    /// "Short".truncated(to: 10)      // "Short"
    /// ```
    func truncated(to length: Int,
                   trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        }
        return self
    }
    
    // MARK: - Whitespace Handling
    
    /// Remove all whitespace and newlines
    var removingWhitespace: String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
    }
    
    /// Trim whitespace and newlines from both ends
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Optional String Extensions

extension Optional where Wrapped == String {
    
    /// Check if optional string is nil or empty
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
    /// Unwrap optional string with default empty string
    var orEmpty: String {
        self ?? ""
    }
}

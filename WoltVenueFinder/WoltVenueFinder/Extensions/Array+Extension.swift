//
//  Array+extension.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//

import Foundation

// MARK: - Array Extensions (Identifiable Elements)

extension Array where Element: Identifiable {
    
    /// Remove duplicates based on id
    /// Useful for ensuring unique venue lists from API
    ///
    /// Example:
    /// ```swift
    /// let venues = [venue1, venue2, venue1] // venue1 duplicated
    /// let unique = venues.removingDuplicates() // [venue1, venue2]
    /// ```
    func removingDuplicates() -> [Element] {
        var seen = Set<Element.ID>()
        return self.filter { element in
            if seen.contains(element.id) {
                return false
            } else {
                seen.insert(element.id)
                return true
            }
        }
    }
    
    /// Find element by ID
    /// - Parameter id: The ID to search for
    /// - Returns: First element with matching ID, or nil
    ///
    /// Example:
    /// ```swift
    /// let venue = venues.find(id: "venue-123")
    /// ```
    func find(id: Element.ID) -> Element? {
        self.first { $0.id == id }
    }
}

// MARK: - Array Extensions (General)

extension Array {
    
    /// Safely access array element at index
    /// - Parameter index: The index to access
    /// - Returns: Element at index, or nil if out of bounds
    ///
    /// Example:
    /// ```swift
    /// let array = [1, 2, 3]
    /// print(array[safe: 5]) // nil instead of crash
    /// ```
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    /// Check if array is not empty
    var isNotEmpty: Bool {
        !isEmpty
    }
}

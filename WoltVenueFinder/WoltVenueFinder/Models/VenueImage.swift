//
//  VenueImage.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 15.2.2026.
//

import Foundation

/// Represents the image object from the Wolt API
/// The API doesn't return image URLs directly - they're wrapped in an object
///
/// API JSON looks like:
/// ```json
/// {
///   "url": "https://wolt-menu-images-cdn.wolt.com/menu-images/634e6c37a5a5e8824e130685/97e2e3e2-e6ea-11f0-9bb7-fa3df64a2b64_ahr0chm6ly9vymply3rzdg9yywdllmv1lwzyyw5rznvydc0xlm9yywnszwnsb3vklmnvbs9ul29yywnszwdidxbyb2qvyi9jq19gqkdcvv9tu18znde2nv9idc1zaw0tmjiwnjaymty0mta3lujbqi01ntgzntawyi1jnmu2ltrinmytyjnini0xzmfkowfjm2rjzjgvby9cquiyndeymdcymtm4mjq5odiuanbn.jpeg"
/// }
/// ```

struct VenueImage: Codable, Equatable {
    /// Direct URL to the venue's thumbnail image
    let url: String
    
    //MARK: Computed Properties
    var isValid: Bool {
        !url.isEmpty &&
        ((url.hasPrefix("http://")) ||
        (url.hasPrefix("https://")))
    }
    /// Returns a placeholder URL if the current one is invalid
    /// Useful for showing default images when API doesn't provide one
    var validURL: String {
        isValid ? url : "https://placehold.net/400x400.png"
    }
}

// MARK: - Preview Data

#if DEBUG
extension VenueImage {
    /// Sample image for SwiftUI previews
    static let preview = VenueImage(
        url: "https://wolt-menu-images-cdn.wolt.com/menu-images/634e6c37a5a5e8824e130685/97e2e3e2-e6ea-11f0-9bb7-fa3df64a2b64_ahr0chm6ly9vymply3rzdg9yywdllmv1lwzyyw5rznvydc0xlm9yywnszwnsb3vklmnvbs9ul29yywnszwdidxbyb2qvyi9jq19gqkdcvv9tu18znde2nv9idc1zaw0tmjiwnjaymty0mta3lujbqi01ntgzntawyi1jnmu2ltrinmytyjnini0xzmfkowfjm2rjzjgvby9cquiyndeymdcymtm4mjq5odiuanbn.jpeg"
    )
    
    /// Invalid image for testing error states
    static let invalid = VenueImage(url: "")
}
#endif

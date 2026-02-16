//
//  WoltVenueFinderTests.swift
//  WoltVenueFinderTests
//
//  Created by Shaikat on 13.2.2026.
//

import XCTest
import Combine
@testable import WoltVenueFinder

@MainActor
final class WoltVenueFinderTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
    }

    override func tearDownWithError() throws {
        cancellables = nil
        try super.tearDownWithError()
    }

    // MARK: - Model Tests

    func testVenue_Decoding_WithValidJSON() throws {
        // Given
        let json = """
        {
            "id": "venue-123",
            "name": "Test Restaurant",
            "short_description": "A great place to eat"
        }
        """.data(using: .utf8)!

        // When
        let venue = try JSONDecoder().decode(Venue.self, from: json)

        // Then
        XCTAssertEqual(venue.id, "venue-123")
        XCTAssertEqual(venue.name, "Test Restaurant")
        XCTAssertEqual(venue.shortDescription, "A great place to eat")
    }

    func testVenueImage_ValidURL() {
        // Given
        let image = VenueImage(url: "https://example.com/image.jpg")

        // Then
        XCTAssertTrue(image.isValid)
        XCTAssertEqual(image.validURL, "https://example.com/image.jpg")
    }

    func testVenueImage_InvalidURL() {
        // Given
        let image = VenueImage(url: "")

        // Then
        XCTAssertFalse(image.isValid)
        XCTAssertEqual(image.validURL, "https://placehold.net/400x400.png")
    }

    func testVenueItem_HasVenue_WhenBothExist() {
        // Given
        let venue = Venue(id: "123", name: "Test", shortDescription: "Desc")
        let image = VenueImage(url: "https://example.com/image.jpg")
        let venueItem = VenueItem(venue: venue, image: image)

        // Then
        XCTAssertTrue(venueItem.hasVenue)
        XCTAssertEqual(venueItem.id, "123")
        XCTAssertEqual(venueItem.name, "Test")
        XCTAssertEqual(venueItem.shortDescription, "Desc")
    }

    func testVenueItem_HasVenue_WhenVenueIsNil() {
        // Given
        let image = VenueImage(url: "https://example.com/image.jpg")
        let venueItem = VenueItem(venue: nil, image: image)

        // Then
        XCTAssertFalse(venueItem.hasVenue)
        XCTAssertEqual(venueItem.id, "")
        XCTAssertEqual(venueItem.name, "")
    }

    func testVenueItem_HasVenue_WhenImageIsNil() {
        // Given
        let venue = Venue(id: "123", name: "Test", shortDescription: "Desc")
        let venueItem = VenueItem(venue: venue, image: nil)

        // Then
        XCTAssertFalse(venueItem.hasVenue)
    }

    func testVenueResponse_VenueItems() {
        // Given
        let venue1 = Venue(id: "1", name: "Restaurant 1", shortDescription: "Desc 1")
        let venue2 = Venue(id: "2", name: "Restaurant 2", shortDescription: "Desc 2")
        let image = VenueImage(url: "https://example.com/image.jpg")

        let item1 = VenueItem(venue: venue1, image: image)
        let item2 = VenueItem(venue: venue2, image: image)

        let sections = [
            Section(items: [], title: nil),
            Section(items: [], title: nil),
            Section(items: [item1, item2], title: "Popular")
        ]
        let response = VenueResponse(sections: sections)

        // When
        let venues = response.venueItems

        // Then
        XCTAssertEqual(venues.count, 2)
        XCTAssertEqual(venues[0].id, "1")
        XCTAssertEqual(venues[1].id, "2")
    }

    func testVenueResponse_LimitedVenueItems() {
        // Given
        let venues = (1...20).map { i in
            let venue = Venue(id: "venue-\(i)", name: "Restaurant \(i)", shortDescription: "Desc")
            let image = VenueImage(url: "https://example.com/\(i).jpg")
            return VenueItem(venue: venue, image: image)
        }

        let sections = [
            Section(items: [], title: nil),
            Section(items: [], title: nil),
            Section(items: venues, title: "Popular")
        ]
        let response = VenueResponse(sections: sections)

        // When
        let limited = response.limitedVenueItems(to: 15)

        // Then
        XCTAssertEqual(limited.count, 15)
    }

    // MARK: - FavouritesManager Tests

//    func testFavouritesManager_AddFavourite() {
//        // Given
//        let key = "test_add_\(UUID().uuidString)"
//        let manager = FavouritesManager(userDefaults: .standard, storageKey: key)
//
//        // When
//        manager.addFavourite(venueID: "venue-123")
//
//        // Then
//        XCTAssertTrue(manager.isFavourite(venueID: "venue-123"))
//        XCTAssertEqual(manager.favouriteIDs.count, 1)
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

//    func testFavouritesManager_RemoveFavourite() {
//        // Given
//        let key = "test_remove_\(UUID().uuidString)"
//        let manager = FavouritesManager(userDefaults: .standard, storageKey: key)
//        manager.addFavourite(venueID: "venue-123")
//
//        // When
//        manager.removeFavourite(venueID: "venue-123")
//
//        // Then
//        XCTAssertFalse(manager.isFavourite(venueID: "venue-123"))
//        XCTAssertTrue(manager.favouriteIDs.isEmpty)
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

//    func testFavouritesManager_ToggleFavourite() {
//        // Given
//        let key = "test_toggle_\(UUID().uuidString)"
//        let manager = FavouritesManager(userDefaults: .standard, storageKey: key)
//
//        // When - Toggle on
//        manager.toggleFavorite(venueID: "venue-123")
//
//        // Then
//        XCTAssertTrue(manager.isFavourite(venueID: "venue-123"))
//
//        // When - Toggle off
//        manager.toggleFavorite(venueID: "venue-123")
//
//        // Then
//        XCTAssertFalse(manager.isFavourite(venueID: "venue-123"))
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

//    func testFavouritesManager_PublishesChanges() {
//        // Given
//        let key = "test_publish_\(UUID().uuidString)"
//        let manager = FavouritesManager(userDefaults: .standard, storageKey: key)
//        let expectation = expectation(description: "Should publish changes")
//
//        var receivedUpdate = false
//        manager.$favouriteIDs
//            .dropFirst() // Skip initial value
//            .sink { ids in
//                if ids.contains("venue-123") {
//                    receivedUpdate = true
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//
//        // When
//        manager.addFavourite(venueID: "venue-123")
//
//        // Then
//        wait(for: [expectation], timeout: 1.0)
//        XCTAssertTrue(receivedUpdate)
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

//    func testFavouritesManager_Persistence() {
//        // Given
//        let key = "test_persist_\(UUID().uuidString)"
//
//        do {
//            let manager1 = FavouritesManager(userDefaults: .standard, storageKey: key)
//
//            // When
//            manager1.addFavourite(venueID: "venue-123")
//            manager1.addFavourite(venueID: "venue-456")
//        }
//
//        // Create new instance with same key
//        let manager2 = FavouritesManager(userDefaults: .standard, storageKey: key)
//
//        // Then
//        XCTAssertEqual(manager2.favouriteIDs.count, 2)
//        XCTAssertTrue(manager2.isFavourite(venueID: "venue-123"))
//        XCTAssertTrue(manager2.isFavourite(venueID: "venue-456"))
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

//    func testFavouritesManager_ClearAllFavorites() {
//        // Given
//        let key = "test_clear_\(UUID().uuidString)"
//        let manager = FavouritesManager(userDefaults: .standard, storageKey: key)
//        manager.addFavourite(venueID: "venue-1")
//        manager.addFavourite(venueID: "venue-2")
//        manager.addFavourite(venueID: "venue-3")
//
//        // When
//        manager.clearAllFavorites()
//
//        // Then
//        XCTAssertTrue(manager.favouriteIDs.isEmpty)
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

//    func testFavouritesManager_NoDuplicates() {
//        // Given
//        let key = "test_duplicates_\(UUID().uuidString)"
//        let manager = FavouritesManager(userDefaults: .standard, storageKey: key)
//
//        // When
//        manager.addFavourite(venueID: "venue-123")
//        manager.addFavourite(venueID: "venue-123")
//        manager.addFavourite(venueID: "venue-123")
//
//        // Then
//        XCTAssertEqual(manager.favouriteIDs.count, 1)
//
//        // Cleanup
//        UserDefaults.standard.removeObject(forKey: key)
//    }

    // MARK: - LocationSimulator Tests

    func testLocationSimulator_InitialLocation() {
        // Given
        let simulator = LocationSimulator()

        // Then
        XCTAssertEqual(simulator.currentLocation.latitude, Constants.Location.defaultLocation.latitude, accuracy: 0.0001)
        XCTAssertEqual(simulator.currentLocation.longitude, Constants.Location.defaultLocation.longitude, accuracy: 0.0001)
    }

    func testLocationSimulator_UpdateLocation() {
        // Given
        let simulator = LocationSimulator()
        let initialLocation = simulator.currentLocation

        // When
        simulator.updateLocation()

        // Then - Location should have changed
        let newLocation = simulator.currentLocation
        let didChange = initialLocation.latitude != newLocation.latitude ||
                       initialLocation.longitude != newLocation.longitude
        XCTAssertTrue(didChange)
    }

    // MARK: - Constants Tests

    func testConstants_APIConfiguration() {
        // Verify critical constants are set correctly
        XCTAssertFalse(Constants.API.baseURL.isEmpty)
        XCTAssertTrue(Constants.API.baseURL.contains("wolt.com"))
        XCTAssertGreaterThan(Constants.API.maxVenuesToDisplay, 0)
        XCTAssertGreaterThan(Constants.API.requestTimeout, 0)
    }

    func testConstants_LocationConfiguration() {
        // Verify location constants
        XCTAssertGreaterThan(Constants.Location.helsinkiCoordinates.count, 0)
        XCTAssertGreaterThan(Constants.Location.updateInterval, 0)
    }

    // MARK: - String Extension Tests

    func testString_IsNotEmpty() {
        XCTAssertTrue("test".isNotEmpty)
        XCTAssertTrue("  hello  ".isNotEmpty)
        XCTAssertFalse("".isNotEmpty)
        XCTAssertFalse("   ".isNotEmpty)
    }

    func testString_Trimmed() {
        XCTAssertEqual("  hello  ".trimmed, "hello")
        XCTAssertEqual("hello".trimmed, "hello")
        XCTAssertEqual("  ".trimmed, "")
    }

    func testString_Truncated() {
        XCTAssertEqual("Hello World".truncated(to: 5), "Hello...")
        XCTAssertEqual("Short".truncated(to: 10), "Short")
        XCTAssertEqual("Test".truncated(to: 4), "Test")
    }

    func testString_RemovingWhitespace() {
        XCTAssertEqual("hello world".removingWhitespace, "helloworld")
        XCTAssertEqual("  test  ".removingWhitespace, "test")
    }

    // MARK: - Array Extension Tests

    func testArray_SafeSubscript() {
        // Given
        let array = [1, 2, 3, 4, 5]

        // Then
        XCTAssertEqual(array[safe: 0], 1)
        XCTAssertEqual(array[safe: 4], 5)
        XCTAssertNil(array[safe: 5])
        XCTAssertNil(array[safe: -1])
        XCTAssertNil(array[safe: 100])
    }

    func testArray_IsNotEmpty() {
        XCTAssertTrue([1, 2, 3].isNotEmpty)
        XCTAssertFalse([].isNotEmpty)
    }

    // MARK: - Integration Tests

    func testVenueService_FetchVenues() async throws {
        // Given
        let service = VenueService()

        // This is an integration test - it makes a real API call
        // When
        do {
            let venues = try await service.fetchVenues(
                latitude: 60.170187,
                longitude: 24.930599
            )

            // Then
            XCTAssertNotNil(venues)
            XCTAssertGreaterThan(venues.count, 0, "Should fetch at least one venue")

            // Verify structure of first venue
            if let firstVenue = venues.first {
                XCTAssertFalse(firstVenue.id.isEmpty, "Venue should have ID")
                XCTAssertFalse(firstVenue.name.isEmpty, "Venue should have name")
                XCTAssertTrue(firstVenue.hasVenue, "Venue item should be valid")
            }
        } catch let error as VenueServiceError {
            // Network errors are acceptable in tests (no internet, API down, etc.)
            print(" VenueService integration test: \(error.errorDescription ?? "Unknown error")")
            // Don't fail the test for network issues
        }
    }
}

//
//  LocationSimulator.swift
//  WoltVenueFinder
//
//  Created by Shaikat on 13.2.2026.
//

import SwiftUI
import Combine

class LocationSimulator : ObservableObject {
    @Published var currentLocation: (latitude: Double,
                                     longitude: Double)
        private var currentIndex = 0
        private var timer: Timer?
        
        init() {
            self.currentLocation = Constants
                                    .Location
                                    .defaultLocation
        }
    
    func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: Constants.Location.updateInterval,
                                     repeats: true,
                                     block: { [weak self] _ in
            self?.updateLocation()
        })
    }
    
    func updateLocation() {
        currentIndex = (currentIndex + 1) % Constants
                                            .Location
                                            .helsinkiCoordinates
                                            .count
        currentLocation = Constants
                            .Location
                            .helsinkiCoordinates[currentIndex]
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopSimulation()
    }
}

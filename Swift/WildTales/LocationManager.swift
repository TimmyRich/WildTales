//
//  LocationManager.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//

import Combine
import CoreLocation
import Foundation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private var locationManager = CLLocationManager()

    @Published var userLocation: CLLocation?  // To track users location

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            userLocation = location
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

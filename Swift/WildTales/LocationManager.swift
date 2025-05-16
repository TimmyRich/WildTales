//
//  LocationManager.swift
//  WildTales
//
//  Created by Kurt McCullough on 28/3/2025.
//
// This is what MapKit uses to help with user location permissions
// Some of this code was retrieved from (https://developer.apple.com/documentation/corelocation/cllocationmanager)

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
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //highest accuracy of location
    }

    //requests users location
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization() //popup for request for in use authorisation
        //locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation() // updates location
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation] // update location
    ) {
        if let location = locations.first {
            userLocation = location
        }
    }
    
    //any loading errors
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

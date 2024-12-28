//
//  LocationViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import Foundation
import CoreLocation
import Combine

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // If we have something stored from a previous session, set it now:
        if let savedLat = UserDefaults.standard.value(forKey: "UserLatitude") as? Double,
           let savedLon = UserDefaults.standard.value(forKey: "UserLongitude") as? Double {
            self.userLocation = CLLocationCoordinate2D(latitude: savedLat, longitude: savedLon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "UserLatitude")
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "UserLongitude")

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}


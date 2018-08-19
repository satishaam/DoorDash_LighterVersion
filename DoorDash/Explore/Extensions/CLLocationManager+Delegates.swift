//
//  CLLocationManager+Delegates.swift
//  DoorDash
//
//  Created by Satisha AM on 8/12/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            updateMapView()
        } else if status != .notDetermined {
            showEnableLocationServiceAlert()
        }
    }
}

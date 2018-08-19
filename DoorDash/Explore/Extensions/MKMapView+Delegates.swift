//
//  MKMapView+Delegates.swift
//  DoorDash
//
//  Created by Satisha AM on 8/12/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        loadingIndicator.startAnimating()
        addressLabel.text = ""
        if !geocoder.isGeocoding {
            geocoder.reverseGeocodeLocation(CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
    }
}

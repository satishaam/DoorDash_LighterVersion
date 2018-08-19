//
//  MapViewController.swift
//  DoorDash
//
//  Created by Satisha AM on 8/11/18.
//  Copyright © 2018 Satisha AM. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    weak var parentViewCtrl:ExploreViewController?
    
    @IBOutlet weak var confirmAddresszview: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var savedCLLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        loadingIndicator.color = .red
        loadingIndicator.hidesWhenStopped = true
        enableLocationServices()
        confirmAddresszview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmAddress)))
    }
    
    @objc func confirmAddress(_ sender:UIView)  {
        dismiss(animated: true) {
            self.parentViewCtrl?.queryDataWith(lat: self.mapView.centerCoordinate.latitude, long: self.mapView.centerCoordinate.longitude)
            print("lat:  \(self.mapView.centerCoordinate.latitude)")
            print("long:  \(self.mapView.centerCoordinate.longitude)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addPinAnnotation() {
        let pinAnnotation  = MKPinAnnotationView(annotation: MKPointAnnotation(), reuseIdentifier: "annotation")
        pinAnnotation.translatesAutoresizingMaskIntoConstraints = false
        pinAnnotation.pinTintColor = .purple
        pinAnnotation.canShowCallout = true
        pinAnnotation.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.view.addSubview(pinAnnotation)
        
        pinAnnotation.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
        pinAnnotation.widthAnchor.constraint(equalToConstant: 35).isActive = true
        pinAnnotation.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        pinAnnotation.centerYAnchor.constraint(equalTo: mapView.centerYAnchor).isActive = true
    }
    
    func enableLocationServices() {
        
       switch CLLocationManager.authorizationStatus() {
          case .notDetermined:
             // Request when-in-use authorization initially
             locationManager.requestWhenInUseAuthorization()
             break
        
          case .restricted, .denied:
            showEnableLocationServiceAlert()
             break
          case .authorizedWhenInUse:
             // Enable basic location features
            locationManager.startUpdatingLocation()
            updateMapView()
             break
        
          case .authorizedAlways:
             // Enable any of your app's location features
            locationManager.startUpdatingLocation()
            updateMapView()
             break
          }
    }
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        if let _ = error {
            addressLabel.text = "Unable to Find Address for Location"
        } else {
            if let placemarks = placemarks, let placemark:CLPlacemark = placemarks.first {
                    addressLabel.text = placemark.compactAddress
            } else {
                addressLabel.text = "No Matching Addresses Found"
            }
        }
        loadingIndicator.stopAnimating()
    }
    
    func updateMapView() {

        if let savedLoc = savedCLLocation?.coordinate {
            mapView.setCenter(savedLoc, animated: true)
            mapView.region =  MKCoordinateRegionMakeWithDistance(savedLoc, 1000, 1000)
        } else if let locCoordiate = locationManager.location?.coordinate {
            savedCLLocation = CLLocation(latitude: locCoordiate.latitude, longitude: locCoordiate.longitude)
            mapView.setCenter(locCoordiate, animated: true)
            mapView.region =  MKCoordinateRegionMakeWithDistance(locCoordiate, 1000, 1000)
        }
        addPinAnnotation()
    }
    
    func showEnableLocationServiceAlert() {
        let alert = UIAlertController(title: "", message: "Turn on Location Services in Settings to get access to information about  Door Dash participating stores around you", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        }))
        self.present(alert, animated: true)
    }
}


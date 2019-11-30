//
//  MapViewController.swift
//  OnTheMap
//
//  Created by fahad on 19/03/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ContainerViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override var locationsData: LocationsData? {
        didSet {
            updatePins()
        }
    }
    
    var annotations = [MKPointAnnotation]()
    func updatePins() {
        guard let locations = locationsData?.studentLocations else {
            return
        }
        for location in locations {
            
            
            guard let latitude  = location.latitude, let longitude = location.longitude else { return }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let firstName = location.firstName
            let lastName = location.lastName
            let media = location.mediaURL
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinates
            annotaion.title = "\(firstName ?? "") \(lastName ?? "")"
            annotaion.subtitle = media
            annotations.append(annotaion)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinId = "pinId"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    
    

}

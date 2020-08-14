//
//  MapVC.swift
//  Pixel City
//
//  Created by kamrujjaman Joy on 7/30/20.
//  Copyright © 2020 kamrujjaman Joy. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        configLocationServices()
        centerMapOnUserLocation()
        addDoubleTap()
    }
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnUserLocation()
    }

    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapview.addGestureRecognizer(doubleTap)
    }
    
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse{
            centerMapOnUserLocation()
        }
     
    }
    
}

extension MapVC:MKMapViewDelegate{
    func centerMapOnUserLocation(){
             guard let coordinate = locationManager.location?.coordinate else{return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
             mapview.setRegion(coordinateRegion, animated: true)
         mapview.showsUserLocation = true
        
        
         }
    
    @objc func dropPin(sender : UITapGestureRecognizer)  {
        let touchPoint = sender.location(in: mapview)
        let touchCoordinate = mapview.convert(touchPoint, toCoordinateFrom: mapview)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapview.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
                    mapview.setRegion(coordinateRegion, animated: true)
        
    }
    
}
extension MapVC:CLLocationManagerDelegate{
    func configLocationServices() {
        if authorizationStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else{
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
}

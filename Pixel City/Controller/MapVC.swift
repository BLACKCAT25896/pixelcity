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
    
    @IBOutlet weak var pullUpView: UIView!
    
    @IBOutlet weak var pullUpViewHightConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    var screenSize = UIScreen.main.bounds
    
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView : UICollectionView?
    
    
    
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
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        pullUpView.addSubview(collectionView!)
        
        
        
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
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        pullUpViewHightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func animateViewDown() {
        pullUpViewHightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: screenSize.width / 2 - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.style = UIActivityIndicatorView.Style.large
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil{
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLbl() {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: (screenSize.width / 2) - 100, y: 175, width: 200, height: 40)
        progressLbl?.font = UIFont(name: "Avenir Next", size: 18)
        progressLbl?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        progressLbl?.textAlignment = .center
        collectionView?.addSubview(progressLbl!)
    }
    func removeProgressLbl() {
        if progressLbl != nil{
            progressLbl?.removeFromSuperview()
        }
    }
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse{
            centerMapOnUserLocation()
        }
     
    }
    
}

extension MapVC:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pin.pinTintColor = #colorLiteral(red: 0.9647058824, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        pin.animatesDrop = true
        return pin
        
    }
    
    func centerMapOnUserLocation(){
             guard let coordinate = locationManager.location?.coordinate else{return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
             mapview.setRegion(coordinateRegion, animated: true)
         mapview.showsUserLocation = true
        
        
         }
    
    @objc func dropPin(sender : UITapGestureRecognizer)  {
        removePin()
        removeSpinner()
        removeProgressLbl()
        animateViewUp()
        addSwipe()
        addSpinner()
        addProgressLbl()
        let touchPoint = sender.location(in: mapview)
        let touchCoordinate = mapview.convert(touchPoint, toCoordinateFrom: mapview)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapview.addAnnotation(annotation)
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
                    mapview.setRegion(coordinateRegion, animated: true)
        
    }
    func removePin() {
        for annotation in mapview.annotations{
            mapview.removeAnnotation(annotation)
        }
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


extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource{
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell
        return cell!
    }
}

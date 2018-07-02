//
//  MapViewCon.swift
//  NoteTaking
//
//  Created by Shumaz Ahamed Junaidi on 12/7/17.
//  Copyright © 2017 ShumazAhamedJunaidi. All rights reserved.
//
import Foundation
import UIKit
import MapKit
class MapViewCon: UIViewController,CLLocationManagerDelegate{
  @IBOutlet weak var mapView: MKMapView!
    
    let locationManage = CLLocationManager()
    var location: CLLocation!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last as! CLLocation
    }
    
    func displayMapOnSelectImg(){
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.10, 0.10)
        
            let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lattitudeArray[indexCounter], longitudeArray[indexCounter])
            
            let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation,span: span)
             mapView.setRegion(region, animated: true)
             self.mapView.showsUserLocation = true
             
             
             var objectAnnotation = MKPointAnnotation()
             objectAnnotation.coordinate = userLocation
             objectAnnotation.title = "location"
             self.mapView.addAnnotation(objectAnnotation)
            
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            locationManage.delegate = self
             locationManage.desiredAccuracy = kCLLocationAccuracyBest
             locationManage.requestWhenInUseAuthorization()
             locationManage.startUpdatingLocation()
            displayMapOnSelectImg()
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

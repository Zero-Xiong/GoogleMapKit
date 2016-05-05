//
//  MapViewController.swift
//  GoogleMapKit
//
//  Created by xiong on 3/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, TypesTableViewControllerDelegate {
    
    let locationManager = CLLocationManager()
   
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!
  
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var pinImageVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet var pinImageHorizontalConstraint: NSLayoutConstraint!
    
    
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 1000
    
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            //mapView.settings.compassButton = true
        
        }
    }
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        
        fetchNearbyPlaces(mapView.camera.target)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
        
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
            locationManager.stopUpdatingLocation()
            
            fetchNearbyPlaces(location.coordinate)
        }
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
        
        if (gesture) {
            mapPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        self.mapPinImage.fadeOut(0.25)
        return false
    }
    
    func mapView(mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let placeMarket = marker as! PlaceMarker
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = placeMarket.place.name
            
            if let photo = placeMarket.place.photo {
                infoView.placePhoto.image = photo
            }
            else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        }
        
        return nil
    }
    
    func didTapMyLocationButtonForMapView(mapView: GMSMapView) -> Bool {
        mapPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                self.addressLabel.unlock()
                
                self.addressLabel.text = lines.joinWithSeparator("\n")
                
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
                
                UIView.animateWithDuration(0.25) {
                    
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
                    
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius: searchRadius, types: searchedTypes) {
            places in for place: GooglePlace in places {
                let marker = PlaceMarker(place: place)
                
                marker.map = self.mapView
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "Types Segue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! TypesTableViewController
            controller.selectedTypes = searchedTypes
            controller.delegate = self
        }
    }
    
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
        searchedTypes = controller.selectedTypes.sort()
        dismissViewControllerAnimated(true, completion: nil)
        fetchNearbyPlaces(mapView.camera.target)
    }

    

}

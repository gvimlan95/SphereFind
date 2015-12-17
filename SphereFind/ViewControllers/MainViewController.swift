//
//  MainViewController.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/11/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController,CLLocationManagerDelegate {
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    var userCurrentCoordinates :CLLocationCoordinate2D?
    var selectedPath : String?
    var radius : Double?
    
    let types = [["Restaurant","Cafe"],["Hospital","Pharmacy"],["Gas Station","Shopping Mall"],["Clothing Store","Night Club"],["Cinema","Veterinary Care"],["Grocery Of Supermarket","Train Station"],["ATM","Bank"],["Bus Station","Hindu Temple"],["Church","Mosque"]]
    //        ,["Amusement Park"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        if Reachability.isConnectedToNetwork() == true {
//            print("Connected")
//            
//        }else{
//            var alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
//            
//            var settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
//                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
//                if let url = settingsUrl {
//                    UIApplication.sharedApplication().openURL(url)
//                }
//            }
//            
//            var cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
//            alertController.addAction(settingsAction)
////            alertController.addAction(cancelAction)
//            
//            presentViewController(alertController, animated: true, completion: nil)
//        }
        
//        if CLLocationManager.locationServicesEnabled(){
//            switch(CLLocationManager.authorizationStatus()) {
//            case .NotDetermined, .Restricted, .Denied:
//                
//                var alertController = UIAlertController (title: "", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
//                
//                var settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
//                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
//                    if let url = settingsUrl {
//                        UIApplication.sharedApplication().openURL(url)
//                    }
//                }
//                
//                var cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
//                alertController.addAction(settingsAction)
//                //            alertController.addAction(cancelAction)
//                
//                presentViewController(alertController, animated: true, completion: nil)
//
//            case .AuthorizedAlways, .AuthorizedWhenInUse:
//                print("Access")
//            default:
//                print("...")
//            }
//
//        }else{
//            print("Disabled")
//        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first as CLLocation! {
            self.userCurrentCoordinates = location.coordinate
            locationManager.stopUpdatingLocation()
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if (error != nil) {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if let pm = placemarks?.first {
                    self.displayLocationInfo(pm)
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
            

        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        
        var locationString : String?
        
        if let locality =  placemark.locality {
            locationString = (locality) + "\n"
        }
        if let postalCode =  placemark.postalCode {
            locationString =  (locationString)! + (postalCode) + "\n"
        }
        if let administrativeArea =  placemark.administrativeArea {
            locationString = (locationString)! + (administrativeArea) + "\n"
        }
        if let country = placemark.country {
            locationString = (locationString)! + (country)
            
        }
        
        self.locationLabel.text = (locationString)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "mainToList"){
            let nearbyLocationVC = segue.destinationViewController as! NearbyLocationListViewController
            nearbyLocationVC.clickedType = self.selectedPath!
            nearbyLocationVC.userCurrentCoordinates = self.userCurrentCoordinates
        }
    }
    
}

extension MainViewController : UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return types.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! MainCollectionViewCell
        let section = indexPath.section
        let row = indexPath.row
        cell.typeLabel?.text = types[section][row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
}

extension MainViewController : UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        let selected = String(types[section][row])
        self.selectedPath = selected
//        self.performSegueWithIdentifier("mainToSecond", sender: self)
        self.performSegueWithIdentifier("mainToList", sender: self)
    }
}

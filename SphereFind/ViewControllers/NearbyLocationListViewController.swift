//
//  NearbyLocationListViewController.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/16/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyLocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var clickedType = ""
    let types = ["Restaurant":"restaurant","Cafe":"cafe","Hospital":"hospital","Pharmacy":"pharmacy","Gas Station":"gas_station","Shopping Mall":"shopping_mall","Clothing Store":"clothing_store","Night Club":"night_club","Cinema":"cinema","Veterinary Care":"veterinary_care","Grocery Of Supermarket":"grocery_or_supermarket","Train Station":"train_station","ATM":"atm","Bank":"bank","Bus Station":"bus_station","Hindu Temple":"hindu_temple","Church":"church","Mosque":"mosque"]
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var userCurrentCoordinates : CLLocationCoordinate2D?
    var radius : Double?
    let locationManager  = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    var places = [GooglePlace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let radius = prefs.stringForKey("radius"){
            self.radius = (radius as NSString).doubleValue
        }
        else{
            self.radius = 5000
        }
        
        fetchNearbyPlaces(self.userCurrentCoordinates!)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let radius = prefs.stringForKey("radius"){
            self.radius = (radius as NSString).doubleValue
        }

    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        
        dataProvider.fetchPlacesNearCoordinates(coordinate, radius: 2000, types: self.types[clickedType]!) { results in
            self.places = results
            self.tableView.reloadData()
        }
    }
}

extension NearbyLocationListViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("locationListCell", forIndexPath: indexPath) as! NearbyLocationTableViewCell
        let place = places[indexPath.row]
        cell.place = place
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
}

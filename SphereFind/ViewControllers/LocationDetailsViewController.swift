//
//  LocationDetailsViewController.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/15/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationCoordinateLabel: UILabel!
    @IBOutlet weak var locationNowOpenLabel: UILabel!
    
    
    var place : GooglePlace?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationNameLabel.text = place?.name
        let latitude = String(place?.coordinate.latitude)
        let longitude = String(place?.coordinate.longitude)
        
        locationCoordinateLabel.text = ("\(latitude),\(longitude)")
        
        

    }

    @IBAction func goButtonPressed(sender: AnyObject) {
    }
   

}

//
//  GooglePlace.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/7/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Bond

class GooglePlace {
    
    let apiKey = "AIzaSyBTsbKMt3xZA30JBEEXptAQenIF7jv41SI"
    
    let name: String
    let address: String
    let nowOpen : String
    let coordinate: CLLocationCoordinate2D
    var photoReference: String?
    var photo = Observable<UIImage?>(nil)
    var distance : AnyObject?
    
    var session : NSURLSession{
        return NSURLSession.sharedSession()
    }
    
    init(dictionary:NSDictionary)
    {
        name = dictionary["name"] as! String
        address = dictionary["vicinity"] as! String
        
        let location = dictionary["geometry"]?["location"] as! NSDictionary
        let lat = location["lat"] as! CLLocationDegrees
        let lng = location["lng"] as! CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        if let opening_hours = dictionary["opening_hours"] as? NSDictionary {
            let result = opening_hours["open_now"] as! Int
            if result == 1 {
                self.nowOpen = "Yes"
            }else{
                self.nowOpen = "No"
            }
        }else{
            self.nowOpen = "Not Available"
        }
        
        if let photos = dictionary["photos"] as? NSArray {
            let photo = photos.firstObject as! NSDictionary
            photoReference = photo["photo_reference"] as? String
        }
    }
    
}

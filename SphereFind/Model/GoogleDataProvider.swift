//
//  GoogleDataProvider.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/7/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class GoogleDataProvider {
    
    let apiKey = "AIzaSyBTsbKMt3xZA30JBEEXptAQenIF7jv41SI"
    var photoCache = [String:UIImage]()
    var placesTask = NSURLSessionDataTask()
    var placesTask2 = NSURLSessionDataTask()
    var session : NSURLSession{
        return NSURLSession.sharedSession()
    }
    
    func fetchPlacesNearCoordinates(coordinate:CLLocationCoordinate2D, radius:Double,types:String, completion: (([GooglePlace]) -> Void)) -> (){
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&types=\(types)"
//        if placesTask.taskIdentifier > 0 && placesTask.state == NSURLSessionTaskState.Running {
//            placesTask.cancel()
//        }
//        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            if error == nil {
                if let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? NSDictionary {
                    if let results = json["results"] as? NSArray {
                        for rawPlace : AnyObject in results {
                            let place = GooglePlace(dictionary: rawPlace as! NSDictionary)
                            placesArray.append(place)
                            self.fetchDistanceBetweenTwoLocation(coordinate, destination: place.coordinate) { (distance) -> Void in
                                place.distance = distance
                            }
                            if let reference  = place.photoReference {
                                self.fetchPhotoFromReference(reference) {
                                    image in
                                    place.photo.value = image
                                }
                            }
                        }
                    }
                }
            }else{
                print("error >>>>>>  \(error)")
            }
            dispatch_async(dispatch_get_main_queue()){
                completion(placesArray)
            }
        }
        placesTask.resume()
    }
    
    
    func fetchPhotoFromReference(reference:String, completion : ((UIImage?) -> Void)) -> () {
        
        if let photo = photoCache[reference] as UIImage!{
            completion(photo)
        }else{
            
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference)&key=\(apiKey)"
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            session.downloadTaskWithURL(NSURL(string: urlString)!){ (url, response, error) -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let downloadedPhoto = UIImage(data: NSData(contentsOfURL: url!)!)
                self.photoCache[reference] = downloadedPhoto
                dispatch_async(dispatch_get_main_queue()){
                    completion(downloadedPhoto)
                }
                }.resume()
        }
    }
    
    func fetchDistanceBetweenTwoLocation(origin:CLLocationCoordinate2D,destination:CLLocationCoordinate2D,completion:((AnyObject) -> Void)) -> (){
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(origin.latitude),\(origin.longitude)&destinations=\(destination.latitude),\(destination.longitude)&key=AIzaSyAZ-yGxyczhimcysL0yt9yXXrh9R02nx9Q"
        
        placesTask2 = session.dataTaskWithURL(NSURL(string:urlString)!){ (data, response, error) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error == nil {
                if let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: [])) as? NSDictionary {
                    if let results = json["rows"] as? NSArray {
                        
                        for result : AnyObject in results {
                            let json = result["elements"]
                            
                            //print("jsonnnn \(json)")
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    completion(data!)
                }
            }
        }
        placesTask2.resume()
        
    }
}

//
//  GoogleDataProvider.swift
//  GoogleMapKit
//
//  Created by xiong on 4/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class GoogleDataProvider {
    
    //let hostURL : String = "http://192.168.110.128:10000"
    
    let hostURL : String = "http://localhost:10000"
    
    var photoCache = [String:UIImage]()
    var placesTask: NSURLSessionDataTask?
    var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: (([GooglePlace]) -> Void)) -> ()
    {
        var urlString = "\(hostURL)/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
        let typesString = types.count > 0 ? types.joinWithSeparator("|") : "food"
        urlString += "&types=\(typesString)"
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        print("#1------ \(urlString)")
        
        if let task = placesTask where task.taskIdentifier > 0 && task.state == .Running {
            task.cancel()
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            var placesArray = [GooglePlace]()
            
            print("#2------ \(placesArray.count)")
            
            if let aData = data {
                let json = JSON(data:aData, options:NSJSONReadingOptions.MutableContainers, error:nil)
                
                print("#3-----\(json["error_message"])")
                
                if let results = json["results"].arrayObject as? [[String : AnyObject]] {
                    
                    print("#4------ \(results.count)")
                    
                    for rawPlace in results {
                        let place = GooglePlace(dictionary: rawPlace, acceptedTypes: types)
                        placesArray.append(place)
                        if let reference = place.photoReference {
                            
                            print("#5------ \(reference)")
                            
                            self.fetchPhotoFromReference(reference) { image in
                                place.photo = image
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                completion(placesArray)
            }
        }
        placesTask?.resume()
    }
    
    
    func fetchPhotoFromReference(reference: String, completion: ((UIImage?) -> Void)) -> () {
        if let photo = photoCache[reference] as UIImage? {
            completion(photo)
        } else {
            let urlString = "\(hostURL)/maps/api/place/photo?maxwidth=200&photoreference=\(reference)"
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            session.downloadTaskWithURL(NSURL(string: urlString)!) {url, response, error in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let url = url {
                    let downloadedPhoto = UIImage(data: NSData(contentsOfURL: url)!)
                    self.photoCache[reference] = downloadedPhoto
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(downloadedPhoto)
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(nil)
                    }
                }
                }.resume()
        }
    }
}

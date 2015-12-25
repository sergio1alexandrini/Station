//
//  Functions.swift
//  Stations
//
//  Created by Александр on 22.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit


func afterDelay(seconds: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}

func GetDataFromCities(cities : [City]) -> ([Int : [City]], [Country], [String : Country]){
    var i = 0;
    var countries = [Country]()
    var countriesDict = [String : Country]()
    var lookUp = [Int : [City]]()
    for city in cities{
        if let country = countriesDict[city.countryTitle] {
            lookUp[country.countryId]!.append(city)
        } else{
            let country = Country(id: i++, title: city.countryTitle)
            countries.append(country)
            countriesDict[city.countryTitle] = country
            
            var newArr = [City]()
            newArr.append(city)
            lookUp[country.countryId] = newArr
        }
    }
    
    return (sortLookupByName(lookUp), sortLocationsByName(countries) as! [Country], countriesDict)
}


func toDictionary(cities : [City]) -> [Int : City]{
    var res = [Int : City]()
    for city in cities{
        res[city.cityId] = city
    }
    
    return res
}

func sortLocationsByName(locations : [Location]) -> [Location]{
    return locations.sort {$0.Title.compare($1.Title) == .OrderedAscending }
}


func sortLookupByName<TKey : Hashable>(lookUp  : [TKey : [City]]) -> [TKey : [City]]{
    var res = [TKey : [City]]()
    for (key, value) in lookUp{
        let sortedArr = sortLocationsByName(value) as! [City]
        res[key] = sortedArr
    }
    
    return res
}

func notifyUser(controller : UIViewController, title: String, message: String) -> Void
{
    let alert = UIAlertController(title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.Alert)
    
    let cancelAction = UIAlertAction(title: "OK",
        style: .Cancel, handler: nil)
    
    alert.addAction(cancelAction)
    controller.presentViewController(alert, animated: true,
        completion: nil)
}


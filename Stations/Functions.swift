//
//  Functions.swift
//  Stations
//
//  Created by Александр on 22.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

func GetCountries(cities : [City]) -> ([Int : [City]], [Country], [String : Country]){
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
    
    return (lookUp, countries, countriesDict)
}

func toDictionary(cities : [City]) -> [Int : City]{
    var res = [Int : City]()
    for city in cities{
        res[city.cityId] = city
    }
    
    return res
}


class JsonParser {
    private let file = "allStations"
    
    private func ParseStationsFromJson(json : JSON) -> [Station]{
        var stations = [Station]()
        
        for (_, station):(String, JSON) in json {
            let countryTitle : String = station["countryTitle"].string!
            let districtTitle : String = station["districtTitle"].string!
            let cityId : Int = station["cityId"].int!
            let cityTitle : String = station["cityTitle"].string!
            let regionTitle : String = station["regionTitle"].string!
            
            let latitude  = station["point"]["latitude"].double!
            let longitude  = station["point"]["longitude"].double!
            
            let point = CLLocation(latitude: latitude, longitude: longitude)
            
            let stationId = station["stationId"].int!
            let stationTitle = station["stationTitle"].string!
            
            let station = Station(countryTitle: countryTitle, point: point, districtTitle: districtTitle, cityId: cityId, cityTitle: cityTitle, regionTitle: regionTitle, stationId: stationId, stationTitle: stationTitle)
            
            stations.append(station)
        }
        
        return stations
    }
    
    private func GetCitiesFromJson(json : JSON) -> [City]{
        var cities = [City]()
        
        for (_, city):(String, JSON) in json {
            let countryTitle : String = city["countryTitle"].string!
            let districtTitle : String = city["districtTitle"].string!
            let cityId : Int = city["cityId"].int!
            let cityTitle : String = city["cityTitle"].string!
            let regionTitle : String = city["regionTitle"].string!
            
            let latitude  = city["point"]["latitude"].double!
            let longitude  = city["point"]["longitude"].double!
            
            let point = CLLocation(latitude: latitude, longitude: longitude)
            
            let stationsJson = city["stations"]
            let stations = ParseStationsFromJson(stationsJson)
            
            let city = City(countryTitle: countryTitle, point: point, districtTitle: districtTitle, cityId: cityId, cityTitle: cityTitle, regionTitle: regionTitle, stations: stations)
            
            cities.append(city)
        }
        
        return cities
    }
    
    func Parse() -> ([City],[City])?{
        if let path = NSBundle.mainBundle().URLForResource(file, withExtension: "json"),
            let jsonData = NSData(contentsOfURL: path){
            let json = JSON(data: jsonData)
            
            let citiesFromJson = json["citiesFrom"]
            let citiesToJson = json["citiesTo"]
            
            let citiesFrom = GetCitiesFromJson(citiesFromJson)
            let citiesTo = GetCitiesFromJson(citiesToJson)
            
            return (citiesFrom, citiesTo)
        }

        return nil
    }
}


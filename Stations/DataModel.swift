//
//  DataModel.swift
//  Stations
//
//  Created by Александр on 25.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit

class DataModel{
    var parser = JsonParser()
    
    var countriesFromDictionaryByCountryTitle = [String : Country]()
    var countriesToDictionaryByCountryTitle = [String : Country]()
    
    var countriesFromLookUp = [Int : [City]]()
    var countriesToLookUp = [Int : [City]]()
    
    var citiesFromDict = [Int : City]()
    var citiesToDict = [Int : City]()
    
    var countriesFrom = [Country]()
    var countriesTo = [Country]()
    
    var citiesFrom = [City]()
    var citiesTo = [City]()
    
    var stationsFrom = [Station]()
    var stationsTo = [Station]()
    
    func LoadData(){
        let data = parser.Parse()
        if data == nil {
            notifyUser(UIApplication.sharedApplication().windows[0].rootViewController!, title: "Ошибка!", message: "Возникла ошибка при чтении списка станций из файла.")
        } else {
            prepareData(data!)
        }
    }
    
    private func prepareData(cities :([City],[City])){
        for city in cities.0{
            stationsFrom.appendContentsOf(city.stations)
        }
        stationsFrom = sortLocationsByName(stationsFrom) as! [Station]
        
        for city in cities.1{
            stationsTo.appendContentsOf(city.stations)
        }
        stationsTo = sortLocationsByName(stationsTo) as! [Station]
        
        citiesFromDict = toDictionary(cities.0)
        citiesToDict = toDictionary(cities.1)
        
        citiesFrom = sortLocationsByName(cities.0) as! [City]
        citiesTo = sortLocationsByName(cities.1) as! [City]
        
        (countriesFromLookUp,
            countriesFrom,
            countriesFromDictionaryByCountryTitle) = GetDataFromCities(cities.0)
        
        (countriesToLookUp,
            countriesTo,
            countriesToDictionaryByCountryTitle) = GetDataFromCities(cities.1)
    }

}

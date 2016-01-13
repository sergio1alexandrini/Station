//
//  DataModel.swift
//  Stations
//
//  Created by Александр on 25.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit

class DataModel{
    
    var delegate: ProgressUpdaterDelegate! {
        didSet{
            parser.delegate = delegate
        }
    }
    
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
        
        //
        self.delegate.updateProgress(1.25)
        
        for city in cities.1{
            stationsTo.appendContentsOf(city.stations)
        }
        stationsTo = sortLocationsByName(stationsTo) as! [Station]
        
        //
        self.delegate.updateProgress(1.25)
        
        citiesFromDict = toDictionary(cities.0)
        
        //
        self.delegate.updateProgress(1.25)
        
        citiesToDict = toDictionary(cities.1)
        
        //
        self.delegate.updateProgress(1.25)
        
        citiesFrom = sortLocationsByName(cities.0) as! [City]
        
        //
        self.delegate.updateProgress(1.25)
        
        citiesTo = sortLocationsByName(cities.1) as! [City]
        
        //
        self.delegate.updateProgress(1.25)
        
        (countriesFromLookUp,
            countriesFrom,
            countriesFromDictionaryByCountryTitle) = GetDataFromCities(cities.0)
        
        (countriesToLookUp,
            countriesTo,
            countriesToDictionaryByCountryTitle) = GetDataFromCities(cities.1)
        
        //
        self.delegate.finishProgress()
    }

}

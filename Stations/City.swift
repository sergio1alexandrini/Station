//
//  Country.swift
//  Stations
//
//  Created by Александр on 22.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation

class City : Location {
    var countryTitle : String
    var point : CLLocation
    var districtTitle : String
    var cityId : Int
    var cityTitle : String
    var regionTitle : String
    var stations : [Station]
    
    init (countryTitle : String,
        point : CLLocation,
        districtTitle : String,
        cityId : Int,
        cityTitle : String,
        regionTitle : String,
        stations : [Station]){
            self.countryTitle = countryTitle
            self.point = point
            self.districtTitle = districtTitle
            self.cityId = cityId
            self.cityTitle = cityTitle
            self.regionTitle = regionTitle
            self.stations = stations
        super.init(id: cityId, title: cityTitle)
    }
}
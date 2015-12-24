//
//  Station.swift
//  Stations
//
//  Created by Александр on 21.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import Foundation
import CoreLocation

class Station : Location  {
    var countryTitle : String
    var point : CLLocation
    var districtTitle : String
    var cityId : Int
    var cityTitle : String
    var regionTitle : String
    var stationId : Int
    var stationTitle : String
    
    init (countryTitle : String,
        point : CLLocation,
        districtTitle : String,
         cityId : Int,
         cityTitle : String,
         regionTitle : String,
         stationId : Int,
        stationTitle : String){
            self.countryTitle = countryTitle
            self.point = point
            self.districtTitle = districtTitle
            self.cityId = cityId
            self.cityTitle = cityTitle
            self.regionTitle = regionTitle
            self.stationId = stationId
            self.stationTitle = stationTitle
            super.init(id: stationId, title: stationTitle)
    }
}
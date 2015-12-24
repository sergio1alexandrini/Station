//
//  Country.swift
//  Stations
//
//  Created by Александр on 23.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import Foundation


class Country : Location{
    var countryTitle : String
    var countryId : Int
    
    override init (id : Int, title : String){
        self.countryTitle = title
        self.countryId = id
        super.init(id: id, title: title)
    }
}
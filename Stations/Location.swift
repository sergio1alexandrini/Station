//
//  Location.swift
//  Stations
//
//  Created by Александр on 23.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import Foundation

class Location {
    var _title : String
    var _id : Int
    
    var Id : Int{
        get{
            return self._id
        }
    }
    
    var Title : String{
        get{
            return self._title
        }
    }

    init (id : Int,title : String){
        self._title = title
        self._id = id
    }
}
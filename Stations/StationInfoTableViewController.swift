//
//  StationInfoTableViewController.swift
//  Stations
//
//  Created by Александр on 24.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit

class StationInfoViewController: UITableViewController {

    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var district: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var station: UILabel!
    
    var currentStation : Station!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
    }
    
    func configureLabels(){
        longitude.text = "\(currentStation.point.coordinate.longitude)"
        latitude.text = "\(currentStation.point.coordinate.latitude)"
        station.text = currentStation.stationTitle
        country.text = currentStation.countryTitle
        region.text = currentStation.regionTitle
        city.text = currentStation.cityTitle
        district.text = currentStation.districtTitle
    }
}

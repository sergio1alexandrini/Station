//
//  MainTableViewController.swift
//  Stations
//
//  Created by Александр on 21.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit


protocol CityOrCountryPickerDelegate : class {
    func didPickLocation(location : Location, pickingType : PickType)
}

class CityAndCountryTableViewController: UITableViewController, CityOrCountryPickerDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    weak var delegate : CityAndCountryPickerDelegate!
    
    var isDirectionFrom : Bool = false
    
    var country : Country!
    var city : City!
    
    var countries : [Country]!
    var cities : [City]!
    
    
    var countriesDictionaryByCountryTitle = [String : Country]()
    var countriesLookUp = [Int : [City]]()
    var citiesDict = [Int : City]()
    
    @IBAction func done(){
        delegate.didPickCountryAndCityForDirection(country, city : city, directionFrom : isDirectionFrom)
    }
    
    @IBAction func clear(){
        self.country = nil
        self.city = nil
        configureLabels()
    }
    
    @IBAction func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didPickLocation(location : Location, pickingType : PickType){
        if pickingType == .Country{
            self.country = location as! Country
            self.city = nil
        } else if pickingType == .City{
            self.city = location as! City
            if self.country == nil{
                self.country = countriesDictionaryByCountryTitle[self.city.countryTitle]
            }
        }
        
        configureLabels()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
    }
    
    func configureLabels(){
        doneButton.enabled = country != nil && city != nil
        countryLabel.text = country == nil ? "" : country.countryTitle
        cityLabel.text = city == nil ? "" : city.cityTitle
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as!  SearchTableViewController
        vc.delegate = self
        if segue.identifier == "SelectCity" {
            vc.collection =  country == nil ? cities : countriesLookUp[country.countryId]!
            vc.pickingType = .City
        } else if segue.identifier == "SelectCountry" {
            vc.collection = countries
            vc.pickingType = .Country
        }
    }
}

//
//  MainTableViewController.swift
//  Stations
//
//  Created by Александр on 21.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit

protocol CityAndCountryPickerDelegate : class {
    func didPickCountryAndCityForDirection(country : Country!, city : City!, directionFrom : Bool)
}

protocol StationsPickerDelegate : class {
    func didPickStationForDirection(station : Location, directionFrom : Bool)
}

class StationsViewController: UITableViewController ,CityAndCountryPickerDelegate,
StationsPickerDelegate{
    
    @IBOutlet weak var cellStationTo: UITableViewCell!
    @IBOutlet weak var cellStationFrom: UITableViewCell!
    
    @IBOutlet weak var clarifyFrom: UILabel!
    @IBOutlet weak var stationFrom: UILabel!

    @IBOutlet weak var clarifyTo: UILabel!
    @IBOutlet weak var stationTo: UILabel!

    @IBOutlet weak var departureDate: UILabel!
    
    var parser = JsonParser()
    var locale = NSLocale(localeIdentifier: "ru_RU")
    var datePickerVisible = false
    
    var currentDate = NSDate()
    var maxDateIntervalFromNow : Double = 90
    
    var countriesFromDictString = [String : Country]()
    var countriesToDictString = [String : Country]()
    
    var countriesFromDict = [Int : [City]]()
    var countriesToDict = [Int : [City]]()
    
    var citiesFromDict = [Int : City]()
    var citiesToDict = [Int : City]()
    
    var countriesFrom = [Country]()
    var countriesTo = [Country]()
    
    var citiesFrom = [City]()
    var citiesTo = [City]()
    
    var stationsFrom = [Station]()
    var stationsTo = [Station]()
    
    var countryFrom : Country!
    var countryTo :  Country!
    
    var cityFrom : City!
    var cityTo : City!
    
    var stFrom : Station!
    var stTo : Station!
    
    var date = NSDate()
    
    @IBAction func clearFrom(){
        self.countryFrom = nil
        self.cityFrom = nil
        self.stFrom = nil
        configureLabels()
    }
    
    @IBAction func clearTo(){
        self.countryTo = nil
        self.cityTo = nil
        self.stTo = nil
        configureLabels()
    }
    
    func didPickStationForDirection(station : Location, directionFrom : Bool){
        let _station = station as! Station
        
        if directionFrom{
            countryFrom = countriesFromDictString[_station.countryTitle]
            cityFrom = citiesFromDict[_station.cityId]
            stFrom = _station
        } else {
            countryTo = countriesToDictString[_station.countryTitle]
            cityTo = citiesToDict[_station.cityId]
            stTo = _station
        }
        
        configureLabels()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didPickCountryAndCityForDirection(country : Country!, city : City!, directionFrom : Bool){
        if directionFrom{
            countryFrom = country
            cityFrom = city
            stFrom = nil
        } else {
            countryTo = country
            cityTo = city
            stTo = nil
        }
        
        configureLabels()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cities = parser.Parse()
        prepareData(cities!)
        configureLabels()
        updateDueDateLabel()
    }
    
    func configureLabels(){
        if countryFrom == nil {
            if cityFrom == nil{
                clarifyFrom.text = "Уточнить"
                clarifyFrom.textColor = UIColor.grayColor()
            }
        } else {
            clarifyFrom.text = "\(countryFrom.countryTitle), \(cityFrom.cityTitle)"
            clarifyFrom.textColor = UIColor.blackColor()
            
            
        }
        
        if let _ = stFrom{
            stationFrom.text = stFrom.stationTitle
            stationFrom.textColor = UIColor.blackColor()
            
            cellStationFrom.accessoryType = .DetailDisclosureButton
        } else {
            stationFrom.text = "Станция"
            stationFrom.textColor = UIColor.grayColor()
            
            cellStationFrom.accessoryType = .None
        }

        if countryTo == nil {
            if cityTo == nil{
                clarifyTo.text = "Уточнить"
                clarifyTo.textColor = UIColor.grayColor()
            }
        } else {
            clarifyTo.text = "\(countryTo.countryTitle), \(cityTo.cityTitle)"
            clarifyTo.textColor = UIColor.blackColor()
        }
        
        if let _ = stTo{
            stationTo.text = stTo.stationTitle
            stationTo.textColor = UIColor.blackColor()
            
            cellStationTo.accessoryType = .DetailDisclosureButton
        } else {
            stationTo.text = "Станция"
            stationTo.textColor = UIColor.grayColor()
            
            cellStationTo.accessoryType = .None
        }
        
        departureDate.text = ""
    }
    
    func prepareData(cities :([City],[City])){
        print("prepareData")
        for city in cities.0{
            stationsFrom.appendContentsOf(city.stations)
        }
        
        for city in cities.1{
            stationsTo.appendContentsOf(city.stations)
        }
        
        citiesFromDict = toDictionary(cities.0)
        citiesToDict = toDictionary(cities.1)
        
        citiesFrom = cities.0
        citiesTo = cities.1
        
        (countriesFromDict, countriesFrom, countriesFromDictString) = GetCountries(cities.0)
        (countriesToDict, countriesTo, countriesToDictString) = GetCountries(cities.1)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ClarifyFrom" {
            let nvc = segue.destinationViewController as!  UINavigationController
            let vc = nvc.topViewController as! CityAndCountryTableViewController
            vc.delegate = self
            vc.cities = citiesFrom
            vc.city = cityFrom
            vc.country = countryFrom
            vc.countries = countriesFrom
            vc.countriesDict = countriesFromDict
            vc.citiesDict = citiesFromDict
            vc.countriesDictString = countriesFromDictString
            vc.isFrom = true
        } else if segue.identifier == "ClarifyTo" {
            let nvc = segue.destinationViewController as!  UINavigationController
            let vc = nvc.topViewController as! CityAndCountryTableViewController
            vc.delegate = self
            vc.cities = citiesTo
            vc.city = cityTo
            vc.country = countryTo
            vc.countries = countriesTo
            vc.isFrom = false
            vc.countriesDict = countriesToDict
            vc.countriesDictString = countriesToDictString
            vc.citiesDict = citiesToDict
        }else if segue.identifier == "SelectStationFrom" {
            let vc = segue.destinationViewController as!  SearchTableViewController
            vc.delegateStation = self
            
            vc.collection =  cityFrom == nil ? stationsFrom : cityFrom.stations
            vc.pickingType = .StationFrom
        }else if segue.identifier == "SelectStationTo" {
            let vc = segue.destinationViewController as!  SearchTableViewController
            vc.delegateStation = self
            
            vc.collection =  cityTo == nil ? stationsTo : cityTo.stations
            vc.pickingType = .StationTo
        }else if segue.identifier == "ShowStationFromInfo" {
            let vc = segue.destinationViewController as!  StationInfoViewController
            print(stFrom)
            vc.currentStation = stFrom
        }else if segue.identifier == "ShowStationToInfo" {
            let vc = segue.destinationViewController as!  StationInfoViewController
            print(stTo)
            vc.currentStation = stTo
        }
    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        formatter.locale = locale
        departureDate.text = formatter.stringFromDate(date)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 2)
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 2)
        
        if let dataCell = tableView.cellForRowAtIndexPath(indexPathDateRow){
            dataCell.detailTextLabel!.textColor = dataCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
            datePicker.setDate(date, animated: false)
        }
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 2)
            let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 2)
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.4)
            }
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates() }
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // 1
            if indexPath.section == 2 && indexPath.row == 1 { // 2
                var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as UITableViewCell!
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                    cell.selectionStyle = .None
                    // 3
                    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                    datePicker.locale = locale
                    datePicker.tag = 100
                    
                    datePicker.datePickerMode = UIDatePickerMode.Date;
                    
                    datePicker.minimumDate = currentDate;
                    datePicker.maximumDate = currentDate.dateByAddingTimeInterval(60*60*24*maxDateIntervalFromNow);
                    
                    cell.contentView.addSubview(datePicker)
                    // 4
                    datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
                }
                return cell
                // 5
            } else {
                return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            if !datePickerVisible{
                showDatePicker()
            } else {
                hideDatePicker()
            }
        } else {
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && datePickerVisible {
            return 2
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView,
        var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
            if indexPath.section == 2 && indexPath.row == 1{
                indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            }
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1{
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    func dateChanged(datePicker: UIDatePicker) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .TimeZone], fromDate: datePicker.date)
        date = calendar.dateFromComponents(components)!
        
        updateDueDateLabel()
    }
}

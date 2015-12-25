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
    
    
    var locale = NSLocale(localeIdentifier: "ru_RU")
    var datePickerVisible = false
    
    var currentDate = NSDate()
    var date = NSDate()
    var maxDateIntervalFromNow : Double = 90
    var datePickerHeight : CGFloat = 217
    var tableRowHeight: CGFloat = 44
    
    var dataModel = DataModel()
    var currentCountryFrom : Country!
    var currentCountryTo :  Country!
    
    var currentCityFrom : City!
    var currentCityTo : City!
    
    var currentStationFrom : Station!
    var currentStationTo : Station!
    
    
    @IBAction func clearFrom(){
        self.currentCountryFrom = nil
        self.currentCityFrom = nil
        self.currentStationFrom = nil
        configureLabels()
    }
    
    @IBAction func clearTo(){
        self.currentCountryTo = nil
        self.currentCityTo = nil
        self.currentStationTo = nil
        configureLabels()
    }
    
    func didPickStationForDirection(station : Location, directionFrom : Bool){
        let _station = station as! Station
        
        if directionFrom{
            currentCountryFrom = dataModel.countriesFromDictionaryByCountryTitle[_station.countryTitle]
            currentCityFrom = dataModel.citiesFromDict[_station.cityId]
            currentStationFrom = _station
        } else {
            currentCountryTo = dataModel.countriesToDictionaryByCountryTitle[_station.countryTitle]
            currentCityTo = dataModel.citiesToDict[_station.cityId]
            currentStationTo = _station
        }
        
        configureLabels()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didPickCountryAndCityForDirection(country : Country!, city : City!, directionFrom : Bool){
        if directionFrom{
            currentCountryFrom = country
            currentCityFrom = city
            currentStationFrom = nil
        } else {
            currentCountryTo = country
            currentCityTo = city
            currentStationTo = nil
        }
        
        configureLabels()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel.LoadData()
        
        configureLabels()
        updateDueDateLabel()
    }
    
    func configureLabels(){
        if currentCountryFrom == nil && currentCityFrom == nil{
            clarifyFrom.text = "Уточнить"
            clarifyFrom.textColor = UIColor.grayColor()
        } else {
            clarifyFrom.text = "\(currentCountryFrom.countryTitle), \(currentCityFrom.cityTitle)"
            clarifyFrom.textColor = UIColor.blackColor()
        }
        
        if let _ = currentStationFrom{
            stationFrom.text = currentStationFrom.stationTitle
            stationFrom.textColor = UIColor.blackColor()
            
            cellStationFrom.accessoryType = .DetailDisclosureButton
        } else {
            stationFrom.text = "Станция"
            stationFrom.textColor = UIColor.grayColor()
            
            cellStationFrom.accessoryType = .None
        }

        if currentCountryTo == nil && currentCityTo == nil{
            clarifyTo.text = "Уточнить"
            clarifyTo.textColor = UIColor.grayColor()
        } else {
            clarifyTo.text = "\(currentCountryTo.countryTitle), \(currentCityTo.cityTitle)"
            clarifyTo.textColor = UIColor.blackColor()
        }
        
        if let _ = currentStationTo{
            stationTo.text = currentStationTo.stationTitle
            stationTo.textColor = UIColor.blackColor()
            
            cellStationTo.accessoryType = .DetailDisclosureButton
        } else {
            stationTo.text = "Станция"
            stationTo.textColor = UIColor.grayColor()
            
            cellStationTo.accessoryType = .None
        }
        
        updateDueDateLabel()
    }
    
    func configureDestinationController(controller : CityAndCountryTableViewController, directionFrom : Bool){
        controller.delegate = self
        controller.isDirectionFrom = directionFrom
        if directionFrom {
            controller.cities = dataModel.citiesFrom
            controller.city = currentCityFrom
            controller.country = currentCountryFrom
            controller.countries = dataModel.countriesFrom
            controller.countriesLookUp = dataModel.countriesFromLookUp
            controller.citiesDict = dataModel.citiesFromDict
            controller.countriesDictionaryByCountryTitle = dataModel.countriesFromDictionaryByCountryTitle
        } else {
            controller.cities = dataModel.citiesTo
            controller.city = currentCityTo
            controller.country = currentCountryTo
            controller.countries = dataModel.countriesTo
            controller.countriesLookUp = dataModel.countriesToLookUp
            controller.countriesDictionaryByCountryTitle = dataModel.countriesToDictionaryByCountryTitle
            controller.citiesDict = dataModel.citiesToDict
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ClarifyCityAndCountryFrom" {
            let nvc = segue.destinationViewController as!  UINavigationController
            let vc = nvc.topViewController as! CityAndCountryTableViewController
            configureDestinationController(vc, directionFrom : true)
        } else if segue.identifier == "ClarifyCityAndCountryTo" {
            let nvc = segue.destinationViewController as!  UINavigationController
            let vc = nvc.topViewController as! CityAndCountryTableViewController
            configureDestinationController(vc, directionFrom : false)
        }else if segue.identifier == "SelectStationFrom" {
            let vc = segue.destinationViewController as!  SearchTableViewController
            vc.delegateStation = self
            vc.collection =  currentCityFrom == nil ? dataModel.stationsFrom : currentCityFrom.stations
            vc.pickingType = .StationFrom
        }else if segue.identifier == "SelectStationTo" {
            let vc = segue.destinationViewController as!  SearchTableViewController
            vc.delegateStation = self
            vc.collection =  currentCityTo == nil ? dataModel.stationsTo : currentCityTo.stations
            vc.pickingType = .StationTo
        }else if segue.identifier == "ShowStationInfoFrom" {
            let vc = segue.destinationViewController as!  StationInfoViewController
            vc.currentStation = currentStationFrom
        }else if segue.identifier == "ShowStationInfoTo" {
            let vc = segue.destinationViewController as!  StationInfoViewController
            print(currentStationTo)
            vc.currentStation = currentStationTo
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
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
            datePicker.setDate(date, animated: false)
        }
        
        let offset = tableView.frame.origin.y
        tableView.setContentOffset(CGPointMake(0, offset + tableRowHeight), animated: true)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 2)
            let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 2)

            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
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
            if datePickerVisible{
                hideDatePicker()
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            return datePickerHeight
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

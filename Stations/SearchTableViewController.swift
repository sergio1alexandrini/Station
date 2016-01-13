//
//  CountryTableViewController.swift
//  Stations
//
//  Created by Александр on 22.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit


extension SearchTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text

        filteredCollection = [Location]()
        if searchText!.isEmpty {
            filteredCollection = collection
        } else {
            filteredCollection = collection.filter({ city -> Bool in

                let tmp = NSString(string : city.Title)
                let range = tmp.rangeOfString(searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
        print(filteredCollection)
        tableView.reloadData()
    }
}


class SearchTableViewController: UITableViewController {

    weak var delegate : CityOrCountryPickerDelegate!
    weak var delegateStation : StationsPickerDelegate!
    
    
    var collection : [Location]!
    var pickingType : PickType = .City
    var filteredCollection : [Location]!
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        switch(pickingType){
        case .City :
            title = "Город"
        case .Country :
            title = "Страна"
        case .StationFrom, .StationTo :
            title = "Станция"
        }
        
        filteredCollection = collection
        adjustSearchController()
    }
    
    func adjustSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = UIBarStyle.Black
        searchController.searchBar.barTintColor = UIColor.whiteColor()
        searchController.searchBar.backgroundColor = UIColor.clearColor()
        
        searchController.hidesNavigationBarDuringPresentation = false

        self.presentViewController(self.searchController, animated:true, completion:nil);
        
        self.navigationItem.titleView = searchController.searchBar;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let textLabel = cell.textLabel {
            textLabel.text = filteredCollection[indexPath.row].Title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCollection.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let str = filteredCollection[indexPath.row]
        switch(pickingType){
            case .City, .Country :
                self.delegate!.didPickLocation(str, pickingType: pickingType)
            case .StationFrom :
                self.delegateStation!.didPickStationForDirection(str, directionFrom: true)
            case .StationTo :
                self.delegateStation!.didPickStationForDirection(str, directionFrom: false)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

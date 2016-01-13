//
//  ViewController.swift
//  testloader
//
//  Created by Александр on 26.12.15.
//  Copyright © 2015 Александр. All rights reserved.
//

import UIKit

protocol ProgressUpdaterDelegate : class{
    func finishProgress()
    func updateProgress(add : Float)
}

class LoadingViewController: UIViewController, ProgressUpdaterDelegate  {
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var dataModel = DataModel()
    
    func refreshProgress(){
        progressView.progress = 0.0
        progressLabel.text = "0 %"
    }
    
    func updateProgress(add : Float) {
        dispatch_async(dispatch_get_main_queue(), {
            if self.progressView.progress < 100.0{
                self.progressView.progress += add
                let progressValue = self.progressView.progress
                let str = String.localizedStringWithFormat("%.1f", progressValue * 100)
                self.progressLabel.text = "\(str) %"
            }
        })
    }
    
    func finishProgress() {
        dispatch_async(dispatch_get_main_queue(), {
            self.progressView.progress = 100
            self.progressLabel.text = "100,0 %"
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Start"{
            let nvc = segue.destinationViewController as! UINavigationController
            let vc = nvc.topViewController as! StationsViewController
            vc.dataModel = dataModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.delegate = self

        refreshProgress()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.dataModel.LoadData()
            self.performSegueWithIdentifier("Start", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


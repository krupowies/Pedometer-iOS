//
//  ViewController.swift
//  Projekt HDiSED
//
//  Created by Wojtek Krupowies on 09/09/2020.
//  Copyright © 2020 Wojtek Krupowies i Mateusz Kula. All rights reserved.
//

import UIKit
import CoreMotion
import Firebase
import StepData

class ViewController: UIViewController {

    @IBOutlet weak var numberOfSteps: UILabel!
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //repeatFunc()
        countSteps()
    }
    
    func repeatFunc(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.printDate), userInfo: nil, repeats: true)
    }
    
    @objc func printDate(){
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        // let timeInterval = NSDate().timeIntervalSince1970
        print("day : \(day) month : \(month) year : \(year)")
        print("hour : \(hour) and minutes \(minutes)")
        print("seconds : \(seconds)")
    }
    
    func countSteps() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            print("STEPS : \(response.numberOfSteps)")
                            self.numberOfSteps.text = response.numberOfSteps.stringValue
                        }
                    }
                }
            }
        }
    }
    
    func currentTime()->Calendar {
        let date = Date()
        let calendar = Calendar.current
        
        return calendar
    }
    
    
    func createPack()->StepData {
        let calendar = currentTime()
        let stepValue = Int(numberOfSteps.text) ?? 0
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let pack = StepData
    }
    
    
}


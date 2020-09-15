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

struct StepData {
    let numberOfSteps: Int
    let day: Int
    let month: Int
    let year: Int
    let hour: Int
    let minutes: Int
    let seconds: Int
}



class ViewController: UIViewController {

    @IBOutlet weak var numberOfSteps: UILabel!
    
    let db = Firestore.firestore()
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfSteps.text = "12"
        let testPack = createPack()
        print(testPack)
        sendPack(pack: testPack)
    }
    
//    func repeatFunc(){
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.printData), userInfo: nil, repeats: true)
//    }
    
    
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
    
    
    func createPack()->StepData {
        
        let date = Date()
        let calendar = Calendar.current
        
        if let text = self.numberOfSteps.text, let stepValue = Int(text) {
            
            let yearCur = calendar.component(.year, from: date)
            let monthCur = calendar.component(.month, from: date)
            let dayCur = calendar.component(.day, from: date)
            let hourCur = calendar.component(.hour, from: date)
            let minutesCur = calendar.component(.minute, from: date)
            let secondsCur = calendar.component(.second, from: date)
            
            return StepData(numberOfSteps: stepValue, day: dayCur, month: monthCur, year: yearCur, hour: hourCur, minutes: minutesCur, seconds: secondsCur)
        }
        return StepData(numberOfSteps: 0, day: 0, month: 0, year: 0, hour: 0, minutes: 0, seconds: 0)
    }
    
    func sendPack(pack: StepData) {
        db.collection("steps").addDocument(data:
            ["Number of steps": pack.numberOfSteps,
             "seconds": pack.seconds
        ]) { (error) in
            if let e = error {
                print("Problem found : \(e)")
            } else {
                print("Data saved !!")
            }
        }
    }
    
}


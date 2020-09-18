//
//  ViewController.swift
//  Projekt HDiSED
//
//  Created by Wojtek Krupowies on 09/09/2020.
//  Copyright © 2020 Wojtek Krupowies i Mateusz Kula. All rights reserved.
//

import UIKit
import CoreMotion
import FirebaseCore
import Firebase
import FirebaseFirestore

let db = Firestore.firestore()

struct StepData {
    let numberOfSteps: Int
    let date: String
    let time: String
}



class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfSteps: UILabel!
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    var timer = Timer()
    var stepsTab: [StepData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        countSteps()
        loadData()
    }
    
    func loadData(){
        
        db.collection("steps").order(by: "Number of steps")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.stepsTab = []
            
            if let e = error {
                print("Problem wit loading data. \(e)")
            } else {
                if let snapshotdoc = querySnapshot?.documents {
                    for doc in snapshotdoc {
                        let data = doc.data()
                        if let numberOfSteps = data["Number of steps"] as? Int, let date = data["Date"] as? String, let time = data["Time"] as? String {
                            let newStepData = StepData(numberOfSteps: numberOfSteps, date: date, time: time)
                            self.stepsTab.append(newStepData)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    

    func countSteps() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            print("STEPS : \(response.numberOfSteps)")
                            self.numberOfSteps.text = response.numberOfSteps.stringValue
                            let testPack = self.createPack()
                            print(testPack)
                            self.sendPack(pack: testPack)
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
            
            let dateCur = "\(dayCur).\(monthCur).\(yearCur)"
            let timeCur = "\(hourCur):\(minutesCur):\(secondsCur)"
            
            
            return StepData(numberOfSteps: stepValue, date: dateCur, time: timeCur)
        }
        return StepData(numberOfSteps: 0, date: "00.00.0000", time: "00:00")
    }
    
    func sendPack(pack: StepData) {
        db.collection("steps").addDocument(data:
            ["Number of steps": pack.numberOfSteps,
             "Date": pack.date,
             "Time": pack.time
        ]) { (error) in
            if let e = error {
                print("Problem found : \(e)")
            } else {
                print("Data saved !!")
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        let cellText: String = "Date: \(stepsTab[indexPath.row].date), \(stepsTab[indexPath.row].time) Steps: \(stepsTab[indexPath.row].numberOfSteps)"
        
        cell.textLabel?.text = cellText
            
        return cell
    }
}

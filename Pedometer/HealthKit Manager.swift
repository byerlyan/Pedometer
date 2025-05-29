//
//  HealthKit Manager.swift
//  Pedometer
//
//  Created by Andrew Byerly on 5/28/25.
//

import Foundation
import HealthKit
import WidgetKit

@Observable class HealthKitManager {
    
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    var stepsToday: Int = 0
    var stepsYesterday: Int = 0
    
    var stepsThisWeek : [Int : Int] = [0:0, 1:0, 2:0, 3:0, 4:0, 5:0, 6:0]
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let toReads = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available")
            return
        }
        healthStore.requestAuthorization(toShare: nil, read: toReads){
            success, error in
            if success {
                print("Authorization successful")
                self.getAllData()
            } else {
                print("\(String(describing: error))")
            }
        }
        
    }
    
    func getAllData(){
        print("===========================================")
        print("Getting all HealthKit data...")
        getTodayStepCount()
        print("DATAS FETCHED: ")
        print("\(stepsToday) steps today")
        print("Done getting data...")
        print("===========================================")
        
    }
    
    func getTodayStepCount() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: [])
        
        print("attempting to get step count for \(startDate)")
        
        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            (_, results, error) in
            guard let results = results, let sum = results.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            print("got the steps: \(steps)")
            self.stepsToday = steps
        }
        healthStore.execute(query)
    }
}

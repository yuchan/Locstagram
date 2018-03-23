//
//  HK.swift
//  Locstagram
//
//  Created by Yusuke Ohashi on 2018/03/23.
//  Copyright © 2018 Yusuke Ohashi. All rights reserved.
//

import Foundation
import HealthKit

struct HKWrapper {
    let healthStore: HKHealthStore = HKHealthStore()

    func request() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }

        let readSet: Set<HKQuantityType> = [HKQuantityType.quantityType(forIdentifier: .stepCount)!]

        healthStore.requestAuthorization(toShare: nil, read: readSet) { (success, error) in
            if !success {
                debugPrint(error)
            }
        }

        healthStore.enableBackgroundDelivery(for: HKQuantityType.quantityType(forIdentifier: .stepCount)!, frequency: .immediate) { (success, error) in

        }
    }

    func getStepCount() {
        let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)

        HKObserverQuery(sampleType: sampleType!, predicate: nil) { (query, handler, error) in
            if error != nil {
                debugPrint("*** An error occured while setting up the stepCount observer. \(error?.localizedDescription) ***")
                abort()
            }
            print(query)
            handler()
        }
    }
}

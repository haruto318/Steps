import UIKit
import HealthKit

class ContentViewModel: NSObject {
    
    @objc dynamic var dataSource: [ListRowItem] = []
    
    func get(fromDate: Date, toDate: Date) {
        let healthStore = HKHealthStore()
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                let query = HKSampleQuery(
                    sampleType: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                    predicate: HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: []),
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]
                ) { query, results, error in
                    guard error == nil else {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    if let quantitySamples = results as? [HKQuantitySample] {
                        let listItems = quantitySamples.map { sample -> ListRowItem in
                            let listItem = ListRowItem(
                                id: sample.uuid.uuidString,
                                datetime: sample.endDate,
                                value: String(sample.quantity.doubleValue(for: HKUnit.meter()))
                            )
                            return listItem
                        }
                        
                        DispatchQueue.main.async {
                            self.dataSource = listItems
                        }
                    }
                }
                
                healthStore.execute(query)
            } else {
                print("データにアクセスできません")
            }
        }
    }
}

struct ListRowItem {
    let id: String
    let datetime: Date
    let value: String
}


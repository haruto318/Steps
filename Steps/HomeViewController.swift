//
//  HomeViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/20.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    var statisticsCollection: HKStatisticsCollection?
    
    var dateArray: [String] = []
    var stepArray: [Float] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let readDataTypes = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ])
        //    ヘルスケアデータのアクセス許可
        HKHealthStore().requestAuthorization(toShare: nil, read: readDataTypes) { success, _ in
            if success {
                self.getSteps()
                self.getDistance()
            } else {
                return
            }
        }
        print(dateArray)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(dateArray.isEmpty)
    }
    

    func getSteps(){
        let calendar = Calendar.current
        let day = -7
        let now = Date()
        let today = calendar.startOfDay(for: now)
                
        // endは今でいい
        let endDate = now
        // startはdayを今日から加算した
        let startDate = calendar.date(byAdding: .day, value: day, to: today)!        // 今日の始まりの0時からアンカーにしたい
        let anchorDate = today
                
        var intervalComponents = DateComponents()
        intervalComponents.day = 1

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let statsOptions: HKStatisticsOptions = [.separateBySource, .cumulativeSum]
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: statsOptions, anchorDate: anchorDate, intervalComponents: intervalComponents)
            
        let dateFormatter = DateFormatter()
        let graphFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        graphFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        graphFormatter.locale = Locale(identifier: "ja_JP")
        graphFormatter.dateFormat = "yyyy/MM/dd"
        print("todaytoday", dateFormatter.string(from: today) , ":" , dateFormatter.string(from: now))
            
        print("\(startDate) - \(endDate)")
        print("anchorDate: \(anchorDate)")
        
        query.initialResultsHandler = { [unowned self] query, result, error in
            guard let result = result, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.statisticsCollection = result
                for item in result.statistics() {
                    if dateFormatter.string(from: today) == dateFormatter.string(from: item.startDate) {
                        let todaySteps = item.sumQuantity()?.doubleValue(for: .count()) ?? 0
                        self.stepLabel.text = "\(Int(todaySteps))"
//                        Realmに登録
                    } else {
                        self.stepLabel.text = "0"
                    }
                    print(graphFormatter.string(from: item.startDate))
                    dateArray.append(graphFormatter.string(from: item.startDate))
//                    print("\(dateFormatter.string(from: item.startDate)) - \(dateFormatter.string(from: item.endDate))\(item.sumQuantity()?.doubleValue(for: .count()) ?? 0.0)")
                }
            }
        }
        HKHealthStore().execute(query)
    }

    func getDistance(){
        var distanceArray: [Float] = []
        let sevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -0), to: Date())!
        let startDate = Calendar.current.startOfDay(for: sevenDaysAgo)

        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                            end: Date(),
                                                            options: [])

        let query = HKStatisticsCollectionQuery(
            quantityType: HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1))

        query.initialResultsHandler = { _, results, _ in guard let statsCollection = results else { return }
                    /// クエリ結果から期間（開始日・終了日）を指定して歩数の統計情報を取り出す。
            statsCollection.enumerateStatistics(from: startDate, to: Date()) { statistics, _ in
                        /// `statistics` に最小単位（今回は１日分の歩数）のサンプルデータが返ってくる。
                        /// `statistics.sumQuantity()` でサンプルデータの合計（１日の合計歩数）を取得する。
                    if let quantity = statistics.sumQuantity() {

                        let distanceValue = quantity.doubleValue(for: HKUnit.meter())
                        let kiloDistance = distanceValue/1000
                        let distanceFloor = floor(kiloDistance*100)/100
                        distanceArray.append(Float(distanceFloor))
                        
                        DispatchQueue.main.async {
                            self.distanceLabel.text = "\(distanceArray[0])"
                        }
                        print("distance", distanceArray)
                    } else {
                        // No Data
                        distanceArray.append(0)
                        DispatchQueue.main.async {
                            self.distanceLabel.text = "\(distanceArray[0])"
                        }

                        print("distance", distanceArray)
                    }
                }
            }
        HKHealthStore().execute(query)
    }

}

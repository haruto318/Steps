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
            }
        }
    }
    

    func getSteps(){
        var stepArray: [Int] = []
        let sevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -0), to: Date())!
        let startDate = Calendar.current.startOfDay(for: sevenDaysAgo)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                            end: Date(),
                                                            options: [])
        
        let query = HKStatisticsCollectionQuery(
            quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
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
                            /// サンプルデータは`quantity.doubleValue`で取り出し、単位を指定して取得する。
                            /// 単位：歩数の場合`HKUnit.count()`と指定する。（歩行速度の場合：`HKUnit.meter()`、歩行距離の場合：`HKUnit(from: "m/s")`といった単位を指定する。）
                        let stepValue = quantity.doubleValue(for: HKUnit.count())
                        /// 取得した歩数を配列に格納する。
                        stepArray.append(Int(stepValue))
                        DispatchQueue.main.async {
                            self.stepLabel.text = "\(stepArray[0])"
                        }
                        print("sampleArray", stepArray)
                    } else {
                        // No Data
                        stepArray.append(0)
                        DispatchQueue.main.async {
                            self.stepLabel.text = "\(stepArray[0])"
                        }

                        print("sampleArray", stepArray)
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

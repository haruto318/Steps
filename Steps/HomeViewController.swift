//
//  HomeViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/20.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HKHealthStore.isHealthDataAvailable() {
            dataPermission()
        } else {
            print("非対応")
        }
        // Do any additional setup after loading the view.
    }
    
//    ヘルスケアデータのアクセス許可
    func dataPermission(){
        let healthStore = HKHealthStore()
        // 読み込むデータ
        let type = Set([
                    HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount )!
                ])
         
        healthStore.requestAuthorization(toShare: [], read: type, completion: { success, error in
            
            if !success {
                            // エラー処理
            }

        })
    }
    

    
}

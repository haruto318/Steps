//
//  HomeViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/20.
//

import UIKit
import HealthKit
import RealmSwift
import Charts

class HomeViewController: UIViewController{
    
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var chartContainerView: UIView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var statisticsCollection: HKStatisticsCollection?
    
    var dateArray: [String] = []
    var graphDateArray: [String] = []
    var stepArray: [Int] = []
    var distanceArray: [Float] = []
    
    let realm = try! Realm()
    
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
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        chartContainerView.layer.cornerRadius = 20
        chartContainerView.clipsToBounds = true
        
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
        let memoryFormatter = DateFormatter()
        let graphFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        memoryFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        memoryFormatter.locale = Locale(identifier: "ja_JP")
        memoryFormatter.dateFormat = "yyyy/MM/dd"
        
        graphFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        graphFormatter.locale = Locale(identifier: "ja_JP")
        graphFormatter.dateFormat = "MM/dd"
        print("todaytoday", dateFormatter.string(from: today) , ":" , dateFormatter.string(from: now))
        
        print("\(startDate) - \(endDate)")
        print("anchorDate: \(anchorDate)")
        
        query.initialResultsHandler = { [unowned self] query, result, error in
            guard let result = result, error == nil else {
                return
            }
            
            DispatchQueue.main.async { [self] in
                self.statisticsCollection = result
                for item in result.statistics() {
                    if dateFormatter.string(from: today) == dateFormatter.string(from: item.startDate) {
                        let todaySteps = item.sumQuantity()?.doubleValue(for: .count()) ?? 0
                        self.stepLabel.text = "\(Int(todaySteps))"
                    } else {
                        self.stepLabel.text = "0"
                    }
                    print(memoryFormatter.string(from: item.startDate))
                    self.dateArray.append(memoryFormatter.string(from: item.startDate))
                    self.graphDateArray.append(graphFormatter.string(from: item.startDate))
                    self.stepArray.append(Int(item.sumQuantity()?.doubleValue(for: .count()) ?? 0))
                    
                                        print("\(dateFormatter.string(from: item.startDate)) - \(dateFormatter.string(from: item.endDate))\(item.sumQuantity()?.doubleValue(for: .count()) ?? 0.0)")
                }
                print(dateArray)
                print(graphDateArray)
                print(stepArray)
                print(distanceArray)
            }
        }
        HKHealthStore().execute(query)
    }
    
    
    func getDistance(){
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
        let quantityType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let statsOptions: HKStatisticsOptions = [.separateBySource, .cumulativeSum]
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: statsOptions, anchorDate: anchorDate, intervalComponents: intervalComponents)
        
        let dateFormatter = DateFormatter()
        let memoryFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        memoryFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        memoryFormatter.locale = Locale(identifier: "ja_JP")
        memoryFormatter.dateFormat = "yyyy/MM/dd"
    
        print("todaytoday", dateFormatter.string(from: today) , ":" , dateFormatter.string(from: now))
        
        print("\(startDate) - \(endDate)")
        print("anchorDate: \(anchorDate)")
        
        query.initialResultsHandler = { [unowned self] query, result, error in
            guard let result = result, error == nil else {
                return
            }
            
            DispatchQueue.main.async { [self] in
                self.statisticsCollection = result
                for item in result.statistics() {
                    if dateFormatter.string(from: today) == dateFormatter.string(from: item.startDate) {
                        let todayDistance = item.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
                        let kiloDistance = todayDistance/1000
                        let distanceFloor = floor(kiloDistance*100)/100
                        self.distanceLabel.text = "\(distanceFloor)"
                    } else {
                        self.distanceLabel.text = "0.0"
                    }
                    print(memoryFormatter.string(from: item.startDate))
                    let todayDistance = item.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
                    let kiloDistance = todayDistance/1000
                    let distanceFloor = floor(kiloDistance*100)/100
                    self.distanceArray.append(Float(distanceFloor))
                    
                                        print("\(dateFormatter.string(from: item.startDate)) - \(dateFormatter.string(from: item.endDate))\(item.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0.0)")
                }
                print(dateArray)
                print(stepArray)
                print(distanceArray)
                updateStepRealm(dateArray: self.dateArray, stepArray: self.stepArray, distanceArray: self.distanceArray)
                
                displayChart(xArray: graphDateArray, yArray: stepArray)
                
            }
        }
        HKHealthStore().execute(query)
    }
    
    func updateStepRealm(dateArray: [String], stepArray: [Int], distanceArray: [Float]){
        guard let lastDate = dateArray.last,
              let lastStep = stepArray.last,
              let lastDistance = distanceArray.last else {
            return
        }
        print(lastDate)
        let memory: Memory? = read()
        
        if memory != nil {
            print(memory)
            if memory?.date == lastDate{
                try! realm.write {
                    memory!.steps_num = lastStep
                    memory!.distance = lastDistance
                }
            } else {
                let newMemory = Memory()
                newMemory.date = lastDate
                newMemory.steps_num = lastStep
                newMemory.distance = lastDistance
                try! realm.write {
                    realm.add(newMemory)
                }
            }
        } else {
            let newMemory = Memory()
            newMemory.date = lastDate
            newMemory.steps_num = lastStep
            newMemory.distance = lastDistance
            try! realm.write {
                realm.add(newMemory)
            }
        }
    }
    
    func read() -> Memory? {
        return realm.objects(Memory.self).last
    }
    
    
    
    func displayChart(xArray: [String], yArray: [Int]) {
        var yValues: [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< yArray.count {
            let entries = ChartDataEntry(x: Double(i), y: Double(yArray[i]))
            yValues.append(entries) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
        }
//        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = LineChartDataSet(entries: yValues, label: "Date")
        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
//                dataSet.mode = .cubicBezier
        
        
        // X軸のラベルの位置を下に設定
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xArray)
        lineChartView.xAxis.labelPosition = .bottom
        // X軸のラベルの色を設定
        lineChartView.xAxis.labelTextColor = .systemGray
        // X軸の線、グリッドを非表示にする
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        
        // 右側のY座標軸は非表示にする
        lineChartView.rightAxis.enabled = false
        
        // Y座標の値が0始まりになるように設定
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.leftAxis.enabled = false
        // ラベルの数を設定
        lineChartView.leftAxis.labelCount = 5
        // ラベルの色を設定
        lineChartView.leftAxis.labelTextColor = .systemGray
        // グリッドの色を設定
        lineChartView.leftAxis.gridColor = .systemGray
        // 軸線は非表示にする
        lineChartView.leftAxis.drawAxisLineEnabled = false
        
        lineChartView.legend.enabled = false
        
//                lineChartView.highlightPerTapEnabled = false// プロットをタップして選択不可
        lineChartView.pinchZoomEnabled = false // ピンチズーム不可
        lineChartView.doubleTapToZoomEnabled = false // ダブルタップズーム不可

        
        //グラフの色
        let mainColor = #colorLiteral(red: 0.1137254902, green: 0.8509803922, blue: 0.5843137255, alpha: 1)
        let secondaryColor = #colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1)
        let colors = [
            mainColor.cgColor,
            secondaryColor.cgColor,
            secondaryColor.cgColor
        ] as CFArray
        let locations: [CGFloat] = [0, 0.79, 1]
        if let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors,
            locations: locations
        ) {
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
        }
        
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 3
        dataSet.drawFilledEnabled = true
        
        dataSet.highlightColor = #colorLiteral(red: 0.1137254902, green: 0.8509803922, blue: 0.5843137255, alpha: 1) //各点を選択した時に表示されるx,yの線
        dataSet.drawValuesEnabled = false
        dataSet.colors = [#colorLiteral(red: 0.1137254902, green: 0.8509803922, blue: 0.5843137255, alpha: 1)]
    }
}


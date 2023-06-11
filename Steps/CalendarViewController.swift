//
//  CalendarViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/06/09.
//

import UIKit
import FSCalendar
import RealmSwift


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    let realm = try! Realm()
    var memories: [Memory] = []
    var selectedMemory: Memory? = nil
    
    var eventModels: [[String:Any]] = []
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        memories = readMemories()
        
//        if let savedDiary = realm.objects(Memory.self).filter("date == '\(self.date)'").last {
//            print(savedDiary.steps_num)
//        }
        
//        getModel()
        
    }
    
    
//    func getModel() {
//        let results = realm.objects(Memory.self)
////        var eventModels: [[String:Any]] = []
//        for result in results {
//            eventModels.append(["date": result.date,
//                                "steps_num": result.steps_num,
//                                "distance": result.distance,
//                                "location": result.location,
//                                "photo": result.photo,
//                               ])
//        }
//    }
    
//    func filterModel() {
//        var filterdEvents: [[String:Any]] = []
//        for eventModel in eventModels {
//            if eventModel["date"] as! String == stringFromDate(date: selectedDate as Date, format: "yyyy/MM/dd") {
//                filterdEvents.append(eventModel)
//            }
//        }
////        filterdModels = filterdEvents
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        print(dateFormatter.string(from: date))
//        filterModel()
//        tableView.reloadData()
        
        if let savedDiary = realm.objects(Memory.self).filter("date == '\(dateFormatter.string(from: date))'").last {
            print(savedDiary.steps_num)
        } else {
            print("no data")
        }
    }
    
    func readMemories() -> [Memory]{
        return Array(realm.objects(Memory.self))
    }
        
    
}



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
    var datesWithEvents: Set<String> = []
    var stepsWithEvents: Set<Int> = []
    
    var eventModels: [[String:Any]] = []
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
        memories = readMemories()
        
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        print(dateFormatter.string(from: date))
        
        selectedMemory = realm.objects(Memory.self).filter("date == '\(dateFormatter.string(from: date))'").last
        if selectedMemory != nil {
            self.performSegue(withIdentifier: "visitMemoryView", sender: nil)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let calendarDay = formatter.string(from: date)

        // Realmオブジェクトの生成
        let realm = try! Realm()
        // 参照（全データを取得）
        let memories = realm.objects(Memory.self)

        if memories.count > 0 {
            for i in 0..<memories.count {
                if i == 0 {
                    datesWithEvents = [memories[i].date]
                } else {
                    datesWithEvents.insert(memories[i].date)
                }
            }
        } else {
            datesWithEvents = []
        }
        print(datesWithEvents)
        return datesWithEvents.contains(calendarDay) ? 1 : 0
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        formatter.calendar = Calendar(identifier: .gregorian)
//        formatter.timeZone = TimeZone.current
//        formatter.locale = Locale.current
//        let calendarDay = formatter.string(from: date)
//
//        // Realmオブジェクトの生成
//        let realm = try! Realm()
//        // 参照（全データを取得）
//        let memories = realm.objects(Memory.self)
//
//        if memories.count > 0 {
//            for i in 0..<memories.count {
//                if i == 0 {
//                    stepsWithEvents = [memories[i].steps_num]
//                } else {
//                    stepsWithEvents.insert(memories[i].steps_num)
//                }
//            }
//        } else {
//            stepsWithEvents = []
//        }
//        print(stepsWithEvents)
//        return "\(stepsWithEvents)"
//    }
    
    func readMemories() -> [Memory]{
        return Array(realm.objects(Memory.self))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "visitMemoryView" {
            let MemoryViewController = segue.destination as! MemoryViewController
            MemoryViewController.selectedMemory = self.selectedMemory!
        }
    }
}



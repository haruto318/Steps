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
    var stepsWithEvents: Dictionary<String, Int> = [:]
    var photoWithEvents: Dictionary<String, Data> = [:]
    
    var eventModels: [[String:Any]] = []
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
        calendar.collectionView.register(UINib(nibName: "FSCalendarCustomCell", bundle: nil),forCellWithReuseIdentifier: "FSCalendarCustomCell")
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        memories = readMemories()
        
        
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleOffsetFor date: Date) -> CGPoint {
        CGPoint(x: 0, y: 5)
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
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let calendarDay = formatter.string(from: date)

        var step: String = ""

        // Realmオブジェクトの生成
        let realm = try! Realm()
        // 参照（全データを取得）
        let memories = realm.objects(Memory.self)

        if memories.count > 0 {
            for i in 0..<memories.count {
                if i == 0 {
                    stepsWithEvents = [memories[i].date: memories[i].steps_num]
                    print(memories[i].steps_num)
                } else {
                    stepsWithEvents.updateValue(memories[i].steps_num, forKey: memories[i].date)
                    print(memories[i].steps_num)
                }
            }
        } else {
            stepsWithEvents = [:]
        }
        print(stepsWithEvents)
        print(type(of: calendarDay))
        if stepsWithEvents.keys.contains(calendarDay){
            step = String(stepsWithEvents[calendarDay]!)
            print(step)
            return step
        } else {
            print("what???")
        }

        return ""
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
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
                    photoWithEvents = [memories[i].date: memories[i].photo]
                    print(memories[i].photo)
                } else {
                    photoWithEvents.updateValue(memories[i].photo, forKey: memories[i].date)
                    print(memories[i].photo)
                }
            }
        } else {
            photoWithEvents = [:]
        }
        print(photoWithEvents)
        print(type(of: calendarDay))

        let cell = calendar.dequeueReusableCell(withIdentifier: "FSCalendarCustomCell", for: date, at: position) as! FSCalendarCustomCell

        if photoWithEvents.keys.contains(calendarDay){
            cell.setCell(photoUrl: photoWithEvents[calendarDay]!)
//            return cell
        } else {
            print("hey???")
        }

        return cell
    }

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


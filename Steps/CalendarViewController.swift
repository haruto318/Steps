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



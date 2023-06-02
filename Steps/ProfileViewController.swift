//
//  ProfileViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/06/01.
//

import UIKit
import FSCalendar
import RealmSwift

class ProfileViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource{
    
    @IBOutlet weak var calendar: FSCalendar!
    
    let realm = try! Realm()
    var memories: [Memory] = []
    var selectedMemory: Memory? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
            calendar.dataSource = self
            calendar.delegate = self
            view.addSubview(calendar)

        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

    }
    
    func readMemories() -> [Memory]{
        return Array(realm.objects(Memory.self))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

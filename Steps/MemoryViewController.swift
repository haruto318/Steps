//
//  MemoryViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/25.
//

import UIKit
import RealmSwift

class MemoryViewController: UIViewController {
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    let realm = try! Realm()
    var selectedMemory: Memory!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = selectedMemory.date
        dateLabel.text = "\(selectedMemory.steps_num)"
        distanceLabel.text = "\(selectedMemory.distance)"

        // Do any additional setup after loading the view.
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

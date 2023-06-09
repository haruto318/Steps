//
//  TableViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/23.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    var memories: [Memory] = []
    var selectedMemory: Memory? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MemoryTableViewCell", bundle: nil), forCellReuseIdentifier: "MemoryCell")
        memories = readMemories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoryCell", for: indexPath) as! MemoryTableViewCell
        let item: Memory = memories[indexPath.row]
        cell.setCell(step: item.steps_num, date: item.date, photoUrl: item.photo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMemory = memories[indexPath.row]
        self.performSegue(withIdentifier: "toMemoryView", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func readMemories() -> [Memory]{
        return Array(realm.objects(Memory.self))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemoryView" {
            let MemoryViewController = segue.destination as! MemoryViewController
            MemoryViewController.selectedMemory = self.selectedMemory!
        }
    }

}

//
//  MemoryViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/25.
//

import UIKit
import RealmSwift

class MemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var photoImageView: UIImageView!
    
    let realm = try! Realm()
    var selectedMemory: Memory!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = selectedMemory.date
        stepLabel.text = "\(selectedMemory.steps_num)"
        distanceLabel.text = "\(selectedMemory.distance)"
        photoImageView.image = UIImage(data: selectedMemory.photo)
    }
    
    @IBAction func onTappedCameraButton(){
        presentPickerController(sourceType: .camera)
    }
    
    func presentPickerController(sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        let image = info[.originalImage] as! UIImage
        photoImageView.image = image
        print(type(of: image))
        guard let data = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        try! realm.write {
            selectedMemory!.photo = data
        }
        
    }
    

}

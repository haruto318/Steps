//
//  MemoryViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/25.
//

import UIKit
import RealmSwift

extension UIImage {
       // image with rounded corners
       public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
           let maxRadius = min(size.width, size.height) / 2
           let cornerRadius: CGFloat
           if let radius = radius, radius > 0 && radius <= maxRadius {
               cornerRadius = radius
           } else {
               cornerRadius = maxRadius
           }
           UIGraphicsBeginImageContextWithOptions(size, false, scale)
           let rect = CGRect(origin: .zero, size: size)
           UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
           draw(in: rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }
   }

class MemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var photoImageView: UIImageView!
    
    let realm = try! Realm()
    var selectedMemory: Memory!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = selectedMemory.date
        stepLabel.text = "\(selectedMemory.steps_num)"
        distanceLabel.text = "\(selectedMemory.distance)"
        photoImageView.image = UIImage(data: selectedMemory.photo)
        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
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

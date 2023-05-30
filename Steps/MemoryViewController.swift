//
//  MemoryViewController.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/25.
//

import UIKit
import RealmSwift
import CoreLocation

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

class MemoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    
    let realm = try! Realm()
    var selectedMemory: Memory!
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = selectedMemory.date
        stepLabel.text = "\(selectedMemory.steps_num)"
        distanceLabel.text = "\(selectedMemory.distance)"
        locationLabel.text = selectedMemory.location
        
        photoImageView.image = UIImage(data: selectedMemory.photo)
        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        imageGradient()
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
    }
    
    func imageGradient(){
        let gradient = CAGradientLayer()
        gradient.frame = photoImageView.bounds
        let startColor = UIColor.systemBackground.withAlphaComponent(0).cgColor
        let endColor = UIColor.systemBackground.cgColor
        gradient.colors = [startColor, endColor]
        photoImageView.layer.insertSublayer(gradient, at: 0)
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
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled(){
                    self.locationManager.startUpdatingLocation()
                }
            }
            selectedMemory!.photo = data
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled(){
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

//        self.labelLat.text = "\(userLocation.coordinate.latitude)"
//        self.labelLongi.text = "\(userLocation.coordinate.longitude)"

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                try! self.realm.write {
                    self.selectedMemory!.location = placemark.administrativeArea! + " " + placemark.locality!
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

}

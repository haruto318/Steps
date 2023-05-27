//
//  MemoryTableViewCell.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/05/24.
//

import UIKit

class MemoryTableViewCell: UITableViewCell {
    
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(step: Int, date: String, photoUrl: Data){
        stepLabel.text = "\(step)"
        dateLabel.text = "\(date)"
        photoImageView.image = UIImage(data: photoUrl)
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
        
//        let url = URL(string: photoUrl)
//        do {
//            let data = try Data(contentsOf: url!)
//            let image = UIImage(data: data)
//            photo.image = image
//        } catch let err {
//            print("Error: \(err.localizedDescription)")
//        }
    }
    
}

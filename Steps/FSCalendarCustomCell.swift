//
//  FSCalendarCustomCell.swift
//  Steps
//
//  Created by Haruto Hamano on 2023/06/12.
//

import UIKit
import FSCalendar

class FSCalendarCustomCell: FSCalendarCell {
    
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setCell(photoUrl: Data){
        photoImageView.image = UIImage(data: photoUrl)
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
    }

}

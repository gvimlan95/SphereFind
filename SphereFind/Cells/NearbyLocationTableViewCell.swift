//
//  NearbyLocationTableViewCell.swift
//  SphereFind
//
//  Created by VIMLAN.G on 9/16/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit

class NearbyLocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nowOpenLabel: UILabel!
    
    
    var place : GooglePlace? {
        didSet{
            if let place = self.place {
                self.nameLabel.text = place.name
                self.nowOpenLabel.text = place.nowOpen
                
                if place.photo.value != nil {
                    place.photo.bindTo(self.locationImage.bnd_image)
                }
            }
        }
    }
   
    @IBAction func goButtonPressed(sender: AnyObject) {
        print("Button pressed")
    }

    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

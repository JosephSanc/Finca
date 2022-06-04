//
//  MyCell.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/4/22.
//

import UIKit
import DropDown

class MyCell: DropDownCell {
    
    @IBOutlet var myImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        myImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

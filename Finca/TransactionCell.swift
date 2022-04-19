//
//  TransactionCell.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/18/22.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 3/28/22.
//

import UIKit
import DropDown

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    

    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Travel",
            "Shopping",
            "Health",
            "Gas",
            "Groceries"
        ]
        
        let images = [
            "airplane",
            "bag.fill",
            "heart.fill",
            "fuelpump.fill",
            "leaf.fill"
        ]
        
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = {index, title, cell in
            guard let cell = cell as? MyCell else {
                return
            }
            cell.myImageView.image = UIImage(systemName: images[index])
        }
        
        return menu
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Anchor menu to topview
        menu.anchorView = categoryView
        
        //Create gesture to show menu with selector
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopView))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        
        categoryView.addGestureRecognizer(gesture)
        
        //Print out result for your own verification
        menu.selectionAction = {index, title in
            self.categoryLabel.text = title
        }
        
    }
    
    @objc func didTapTopView(){
        menu.show()
    }

    @IBAction func addTransaction(_ sender: Any) {
        let amount = Float(amountInput.text!) ?? 0.00
        let company = companyInput.text ?? "error company"
        let category = menu.selectedItem ?? "error category"
        
        let transaction = Transaction(amount: amount, company: company, category: category)
        
        print("Amount: \(transaction.amount), Company: \(transaction.company), Category: \(transaction.category)")
    }
    

}


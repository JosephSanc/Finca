//
//  ViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 3/28/22.
//

import UIKit
import DropDown
import Firebase

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var docRef: DocumentReference!
    
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
    
    func getCurrentUser() -> Substring {
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            return UserHelper.getFilteredEmail(email!)
        } else {
            return "Error getting current user"
        }
    }

    //TODO: Refactor this to take user input date instead of the current date like I have below
    @IBAction func addTransaction(_ sender: Any) {
        guard let amount = Float(amountInput.text!) else { return }
        guard let company = companyInput.text else { return }
        guard let category = menu.selectedItem else { return }
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.day = Calendar.current.component(.day, from: Date())
        let userCalender = Calendar(identifier: .gregorian)
        let someDateTime = userCalender.date(from: dateComponents)
        
        let transaction = Transaction(amount: amount, company: company, category: category)
        
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        docRef = Firestore.firestore().document("\(K.UserCollection.userCollentionName)/\(getCurrentUser())/\(K.TransactionCollection.collectionName)/\(year)/\"month\"/\(month)")
        
        let dataToSave: [String: [String: Any]] = ["transaction": ["amount": amount, "company": company, "category": category, "date": someDateTime!]]
        docRef.setData(dataToSave)
        
        print("Amount: \(transaction.amount), Company: \(transaction.company), Category: \(transaction.category)")
    }
    
    @objc func didTapTopView(){
        menu.show()
    }

}


//
//  ViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 3/28/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var categoryInput: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func addTransaction(_ sender: Any) {
        let amount = Float(amountInput.text!) ?? 0.00
        let company = companyInput.text ?? "error company"
        let category = categoryInput.text ?? "category error"
        
        let transaction = Transaction(amount: amount, company: company, category: category)
        
        print("Amount: \(transaction.amount), Company: \(transaction.company), Category: \(transaction.category)")
    }
    

}


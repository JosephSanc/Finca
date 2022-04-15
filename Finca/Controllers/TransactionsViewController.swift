//
//  TransactionsViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/9/22.
//

import UIKit
import Firebase

class TransactionsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let prices = [
        "12.00",
        "38.99",
        "42.50",
        "10.00"
    ]
    
    let companies = [
        "Amazon",
        "Walmart",
        "Costco",
        "Amazon"
    ]
    
    let categories = [
        "Shopping",
        "Groceries",
        "Groceries",
        "Health"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: K.transactionNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.transactionNibName)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //TODO: Delete this
    @IBAction func TestUserBtn(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            print(UserHelper.getFilteredEmail(email!))
        }
    }
    
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped!!")
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.transactionNibName, for: indexPath) as! TransactionCell
        
        cell.amountLabel.text = prices[indexPath.row]
        cell.categoryLabel.text = categories[indexPath.row]
        cell.companyLabel.text = companies[indexPath.row]
        
        return cell
    }
    
    
}

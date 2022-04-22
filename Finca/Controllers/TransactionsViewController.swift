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
    @IBOutlet var monthTxtField: UITextField!
    @IBOutlet var dayTxtField: UITextField!
    @IBOutlet var yearTxtField: UITextField!
    
    let monthPicker = UIPickerView()
    let dayPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    let months = ["January", "February", "March", "April",
                  "May", "June", "July", "August",
                  "September", "October","November", "December"]
    
    let daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    
    let prices = [
        "12.00",
        "38.99",
        "42.50",
        "10.00",
        "123.33"
    ]
    
    let companies = [
        "Amazon",
        "Walmart",
        "Costco",
        "Amazon",
        "The Booga looga store"
    ]
    
    let categories = [
        "Shopping",
        "Groceries",
        "Groceries",
        "Health",
        "Groceries"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: K.transactionNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.transactionNibName)
        tableView.delegate = self
        tableView.dataSource = self
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        dayPicker.delegate = self
        dayPicker.dataSource = self
        
        monthTxtField.text = "Month"
        monthTxtField.inputView = monthPicker
        monthTxtField.textAlignment = .center
        dayTxtField.text = "Day"
        dayTxtField.inputView = dayPicker
        dayTxtField.textAlignment = .center
        
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

extension TransactionsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        monthTxtField.text = months[row]
        monthTxtField.resignFirstResponder()
    }
}

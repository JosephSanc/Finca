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
    
    let monthPicker = UIPickerView()
    let dayPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    lazy var monthPickerDelegate = MonthPickerDelegate(monthTxtField)
    lazy var dayPickerDelegate = DayPickerDelegate(dayTxtField)
    lazy var yearPickerDelegate = YearPickerDelegate(yearTxtField)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: K.transactionNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.transactionNibName)
        tableView.delegate = self
        tableView.dataSource = self
        
        monthPicker.delegate = monthPickerDelegate
        monthPicker.dataSource = monthPickerDelegate
        monthTxtField.text = "Month"
        monthTxtField.inputView = monthPicker
        monthTxtField.textAlignment = .center
        
        dayPicker.delegate = dayPickerDelegate
        dayPicker.dataSource = dayPickerDelegate
        dayTxtField.text = "Day"
        dayTxtField.inputView = dayPicker
        dayTxtField.textAlignment = .center
        
        yearPicker.delegate = yearPickerDelegate
        yearPicker.dataSource = yearPickerDelegate
        yearTxtField.text = "Year"
        yearTxtField.inputView = yearPicker
        yearTxtField.textAlignment = .center
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


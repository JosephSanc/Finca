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
    
    let db = Firestore.firestore()
    
    var amounts: [Float] = []
    var companies: [String] = []
    var categories: [String] = []
    
    let months = ["Month", "January", "February", "March", "April",
                  "May", "June", "July", "August",
                  "September", "October","November", "December"]
    var days: [String] = ((1...31).map {String($0)})
    var years: [String] = ((2020...Calendar.current.component(.year, from: Date())).map {String($0)})
    
    let monthPicker = UIPickerView()
    let dayPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    lazy var monthPickerDelegate = MonthPickerDelegate(months, monthTxtField)
    lazy var dayPickerDelegate = DayPickerDelegate(days, dayTxtField)
    lazy var yearPickerDelegate = YearPickerDelegate(years, yearTxtField)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        days.insert("Day", at: 0)
        years.insert("Year", at: 0)
        
        hideKeyboardWhenTappedAround()
        
        let nib = UINib(nibName: K.transactionNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.transactionNibName)
        tableView.delegate = self
        tableView.dataSource = self
        
        monthPicker.delegate = monthPickerDelegate
        monthPicker.dataSource = monthPickerDelegate
        monthTxtField.delegate = self
        monthTxtField.text = "Month"
        monthTxtField.inputView = monthPicker
        monthTxtField.textAlignment = .center
        
        dayPicker.delegate = dayPickerDelegate
        dayPicker.dataSource = dayPickerDelegate
        dayTxtField.delegate = self
        dayTxtField.text = "Day"
        dayTxtField.inputView = dayPicker
        dayTxtField.textAlignment = .center
        
        yearPicker.delegate = yearPickerDelegate
        yearPicker.dataSource = yearPickerDelegate
        yearTxtField.delegate = self
        yearTxtField.text = "Year"
        yearTxtField.inputView = yearPicker
        yearTxtField.textAlignment = .center
    }
    
    
    @IBAction func getTransactionInfoBtn(_ sender: UIButton) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let month = DateHelper().getMonthNum(monthTxtField.text!)
        let day = dayTxtField.text!
        let year = yearTxtField.text!
        
        if year != "Year" && month == -1 && day == "Day" {
            yearOnly(year: Int(year)!, userID: userID)
        } else if month != -1 && day == "Day" && year == "Year" {
            monthOnly(month: month, userID: userID)
        } else if month != -1 && day != "Day" && year == "Year" {
            monthAndDay(month: month, day: Int(day)!, userID: userID)
        } else if month != -1 && day == "Day" && year != "Year" {
            monthAndYear(month: month, year: Int(year)!, userID: userID)
        } else if month != -1 && day != "Day" && year != "Year" {
            monthDayAndYear(month: month, day: Int(day)!, year: Int(year)!, userID: userID)
        }
        amounts.removeAll()
        categories.removeAll()
        companies.removeAll()
        tableView.reloadData()
    }
    
    //Method for each date filled scenario
    func yearOnly(year: Int, userID: String){
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("year", isEqualTo: year).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let month = document.data()["month"] as! Int
                    let day = document.data()["day"] as! Int
                    let year = document.data()["year"] as! Int
                    let amount = document.data()["amount"] as! Float
                    let company = document.data()["company"] as! String
                    let category = document.data()["category"] as! String
                    let transaction = Transaction(month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
    }
    
    func monthOnly(month: Int, userID: String){
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("month", isEqualTo: month).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let month = document.data()["month"] as! Int
                    let day = document.data()["day"] as! Int
                    let year = document.data()["year"] as! Int
                    let amount = document.data()["amount"] as! Float
                    let company = document.data()["company"] as! String
                    let category = document.data()["category"] as! String
                    let transaction = Transaction(month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
    }
    
    func monthAndDay(month: Int, day: Int, userID: String){
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("month", isEqualTo: month).whereField("day", isEqualTo: day).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let month = document.data()["month"] as! Int
                    let day = document.data()["day"] as! Int
                    let year = document.data()["year"] as! Int
                    let amount = document.data()["amount"] as! Float
                    let company = document.data()["company"] as! String
                    let category = document.data()["category"] as! String
                    let transaction = Transaction(month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
    }
    
    func monthAndYear(month: Int, year: Int, userID: String){
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("month", isEqualTo: month).whereField("year", isEqualTo: year).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let month = document.data()["month"] as! Int
                    let day = document.data()["day"] as! Int
                    let year = document.data()["year"] as! Int
                    let amount = document.data()["amount"] as! Float
                    let company = document.data()["company"] as! String
                    let category = document.data()["category"] as! String
                    let transaction = Transaction(month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
    }
    
    func monthDayAndYear(month: Int, day: Int, year: Int, userID: String){
        db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).whereField("month", isEqualTo: month).whereField("day", isEqualTo: day).whereField("year", isEqualTo: year).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let month = document.data()["month"] as! Int
                    let day = document.data()["day"] as! Int
                    let year = document.data()["year"] as! Int
                    let amount = document.data()["amount"] as! Float
                    let company = document.data()["company"] as! String
                    let category = document.data()["category"] as! String
                    let transaction = Transaction(month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(transaction)")
                }
            }
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

        cell.amountLabel.text = String(amounts[indexPath.row])
        cell.categoryLabel.text = categories[indexPath.row]
        cell.companyLabel.text = companies[indexPath.row]
        
        return cell
    }
}

extension TransactionsViewController: UITextFieldDelegate {
    // Return button tapped
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }

   // Around tapped
   func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTransactionViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }

   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
}


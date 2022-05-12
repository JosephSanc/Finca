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
    
    var transactions: [Transaction] = []
    var amounts: [Float] = []
    var companies: [String] = []
    var categories: [String] = []
    var transactionIDs: [String] = []
    
    let months = ["Month", "January", "February", "March", "April",
                  "May", "June", "July", "August",
                  "September", "October","November", "December"]
    var days: [String] = ((1...31).map {String($0)})
    var years: [String] = ((2020...Calendar.current.component(.year, from: Date())).map {String($0)})
    
    let monthPicker = UIPickerView()
    let dayPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    var currentCellRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        days.insert("Day", at: 0)
        years.insert("Year", at: 0)
        
        hideKeyboardWhenTappedAround()
        
        let nib = UINib(nibName: K.transactionNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.transactionNibName)
        tableView.delegate = self
        tableView.dataSource = self
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthTxtField.delegate = self
        monthTxtField.text = "Month"
        monthTxtField.inputView = monthPicker
        monthTxtField.textAlignment = .center
        
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayTxtField.delegate = self
        dayTxtField.text = "Day"
        dayTxtField.inputView = dayPicker
        dayTxtField.textAlignment = .center
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearTxtField.delegate = self
        yearTxtField.text = "Year"
        yearTxtField.inputView = yearPicker
        yearTxtField.textAlignment = .center
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditTransaction" {
            let editTransactionVC = segue.destination as! EditTransactionViewController
            editTransactionVC.amountStr = String(amounts[currentCellRow])
            editTransactionVC.companyStr = companies[currentCellRow]
            editTransactionVC.categoryStr = categories[currentCellRow]
        }
    }
    
    func showTransactions(){
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
        transactions.removeAll()
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
                    let transaction = Transaction(transactionID: document.documentID, month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.transactions.append(transaction)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.transactionIDs.append(document.documentID)
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
                    let transaction = Transaction(transactionID: document.documentID, month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.transactions.append(transaction)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.transactionIDs.append(document.documentID)
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
                    let transaction = Transaction(transactionID: document.documentID, month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.transactions.append(transaction)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.transactionIDs.append(document.documentID)
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
                    let transaction = Transaction(transactionID: document.documentID, month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.transactions.append(transaction)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.transactionIDs.append(document.documentID)
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
                    let transaction = Transaction(transactionID: document.documentID, month: month, day: day, year: year, amount: amount, company: company, category: category)
                    self.transactions.append(transaction)
                    self.amounts.append(amount)
                    self.companies.append(company)
                    self.categories.append(category)
                    self.transactionIDs.append(document.documentID)
                    self.tableView.reloadData()
                    print("\(document.documentID) => \(transaction)")
                }
            }
        }
    }
    
}

extension TransactionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker {
            return months.count
        } else if pickerView == dayPicker {
            return days.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker {
            return months[row]
        } else if pickerView == dayPicker {
            return days[row]
        } else {
            return years[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthPicker {
            monthTxtField.text = String(months[row])
            monthTxtField.resignFirstResponder()
        } else if pickerView == dayPicker {
            dayTxtField.text = String(days[row])
            dayTxtField.resignFirstResponder()
        } else {
            yearTxtField.text = String(years[row])
            yearTxtField.resignFirstResponder()
        }
        showTransactions()
    }
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.transactionNibName, for: indexPath) as! TransactionCell

        cell.amountLabel.text = String(transactions[indexPath.row].amount)
        cell.categoryLabel.text = transactions[indexPath.row].category
        cell.companyLabel.text = transactions[indexPath.row].company
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            db.collection(K.UserCollection.collectionName).document(userID).collection(K.TransactionCollection.collectionName).document(transactionIDs[indexPath.row]).delete() { err in
                
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCellRow = indexPath.row
        performSegue(withIdentifier: "EditTransaction", sender: self)
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


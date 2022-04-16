//
//  ViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 3/28/22.
//

import UIKit
import Firebase

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountInput: UITextField!
    @IBOutlet weak var companyInput: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    
    var docRef: DocumentReference!
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    let categories = ["", "Gas", "Groceries", "Date night", "Fast Food", "Car Insurance", "Auto", "Parking", "Rent", "Shopping", "Health", "Haircut", "Google Drive", "Apple iCloud", "Danny", "Investments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

        categoryTxtField.inputView = categoryPicker
        categoryTxtField.textAlignment = .center
        
        createDatePicker()
        
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
    
    func createDatePicker(){
        dateTxtField.textAlignment = .center

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneBtn], animated: true)

        dateTxtField.inputAccessoryView = toolbar
        dateTxtField.inputView = datePicker

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }

    @objc func dateDonePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        dateTxtField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    //TODO: Refactor this to take user input date instead of the current date like I have below
    @IBAction func addTransaction(_ sender: Any) {
        
        print(dateTxtField.text!)
//        guard let amount = Float(amountInput.text!) else { return }
//        guard let company = companyInput.text else { return }
//        guard let category = categoryTxtField.text else { return }
//
//        var dateComponents = DateComponents()
//        dateComponents.year = Calendar.current.component(.year, from: Date())
//        dateComponents.month = Calendar.current.component(.month, from: Date())
//        dateComponents.day = Calendar.current.component(.day, from: Date())
//        let userCalender = Calendar(identifier: .gregorian)
//        let someDateTime = userCalender.date(from: dateComponents)
//
//        let year = Calendar.current.component(.year, from: Date())
//        let month = Calendar.current.component(.month, from: Date())
//
//        docRef = Firestore.firestore().document("\(K.UserCollection.userCollentionName)/\(getCurrentUser())/\(K.TransactionCollection.collectionName)/\(year)/\"month\"/\(month)")
//
//        let dataToSave: [String: [String: Any]] = ["transaction": ["amount": amount, "company": company, "category": category, "date": someDateTime!]]
//        docRef.setData(dataToSave)
//
//        print("Amount: \(amount), Company: \(company), Category: \(category)")
    }
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTxtField.text = categories[row]
        categoryTxtField.resignFirstResponder()
    }
}



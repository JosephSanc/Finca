//
//  EditTransactionViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 5/11/22.
//

import Foundation
import UIKit
import Firebase

class EditTransactionViewController: UIViewController {
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var date: UITextField!
    
    var amountStr = ""
    var companyStr = ""
    var categoryStr = ""

    private var db = Firestore.firestore()
    
    let datePicker = UIDatePicker()
    let categoryPicker = UIPickerView()
    
    let categories = ["", "Gas", "Groceries", "Date night", "Fast Food", "Car Insurance", "Auto", "Parking", "Rent", "Shopping", "Health", "Haircut", "Google Drive", "Apple iCloud", "Danny", "Investments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amount.text = amountStr
        company.text = companyStr
        category.text = categoryStr
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        hideKeyboardWhenTappedAround()
        amount.delegate = self
        company.delegate = self

        category.inputView = categoryPicker
        category.textAlignment = .center
        
        createDatePicker()
    }
    
    @IBAction func sayHello(_ sender: UIButton){
        print("Hello")
    }
    
    func createDatePicker(){
        date.textAlignment = .center

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneBtn], animated: true)

        date.inputAccessoryView = toolbar
        date.inputView = datePicker

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }

    @objc func dateDonePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}

extension EditTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        category.text = categories[row]
        category.resignFirstResponder()
    }
}

extension EditTransactionViewController: UITextFieldDelegate {
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

//
//  AccountsViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 6/15/22.
//

/**
 TODO:
    - Make month and year filters to know your budgets in different points of time
    - Make a submit button that only appears if the user edits one of the account values
    - When the submit button is pressed, used validateAllFieldsFilled to make sure all fields are filled
 */
import Foundation
import UIKit

class AccountsViewController: UIViewController {
    @IBOutlet weak var emergencyFundLabel: UILabel!
    @IBOutlet weak var downPaymentLabel: UILabel!
    @IBOutlet weak var macStudioFundLabel: UILabel!
    @IBOutlet weak var wellsFargoCheckingsLabel: UILabel!
    @IBOutlet weak var allyCheckingsLabel: UILabel!
    @IBOutlet weak var rothIRALabel: UILabel!
    @IBOutlet weak var individualBrokerageLabel: UILabel!
    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var fourOneKLabel: UILabel!
    @IBOutlet weak var studentLoansLabel: UILabel!
    @IBOutlet weak var emergencyFundTextField: UITextField!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var macStudioFundTextField: UITextField!
    @IBOutlet weak var wellsFargoCheckingsTextField: UITextField!
    @IBOutlet weak var allyCheckingsTextField: UITextField!
    @IBOutlet weak var rothIRATextField: UITextField!
    @IBOutlet weak var individualBrokerageTextField: UITextField!
    @IBOutlet weak var cryptoTextField: UITextField!
    @IBOutlet weak var fourOneKTextField: UITextField!
    @IBOutlet weak var studentLoansTextField: UITextField!
    @IBOutlet weak var monthFilterTextField: UITextField!
    @IBOutlet weak var yearFilterTextField: UITextField!
    
    let months = K.months
    var years = K.years
    
    let monthPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        years.insert("Year", at: 0)
        
        hideKeyboardWhenTappedAround()
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthFilterTextField.delegate = self
        monthFilterTextField.text = "Month"
        monthFilterTextField.inputView = monthPicker
        monthFilterTextField.textAlignment = .center
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearFilterTextField.delegate = self
        yearFilterTextField.text = "Year"
        yearFilterTextField.inputView = yearPicker
        yearFilterTextField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        monthPicker.selectRow(0, inComponent: 0, animated: false)
        monthFilterTextField.text = months[0]
        yearPicker.selectRow(0, inComponent: 0, animated: false)
        yearFilterTextField.text = years[0]
    }
    
    func inputValidation(textInput: UITextField) {
        let (validation, message): (Bool, String?) = InputValidation.validateField(textInput.text!, .amount)
        
        if !validation {
            let dialogMessage = UIAlertController(title: "Error", message: message!, preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("Ok button tapped")
            }

            dialogMessage.addAction(ok)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func validateAllFieldsFilled() -> Bool {
        inputValidation(textInput: emergencyFundTextField)
        inputValidation(textInput: downPaymentTextField)
        inputValidation(textInput: macStudioFundTextField)
        inputValidation(textInput: wellsFargoCheckingsTextField)
        inputValidation(textInput: allyCheckingsTextField)
        inputValidation(textInput: rothIRATextField)
        inputValidation(textInput: individualBrokerageTextField)
        inputValidation(textInput: cryptoTextField)
        inputValidation(textInput: fourOneKTextField)
        inputValidation(textInput: studentLoansTextField)
        
        if self.presentedViewController as? UIAlertController != nil {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func emergencyFundDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: emergencyFundTextField)
    }
    
    @IBAction func downPaymentDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: downPaymentTextField)
    }
    
    @IBAction func macStudioFundDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: macStudioFundTextField)
    }
    
    @IBAction func wellsFargoCheckingsDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: wellsFargoCheckingsTextField)
    }
    
    @IBAction func allyCheckingsDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: allyCheckingsTextField)
    }
    
    @IBAction func rothIRADidEndEditing(_ sender: UITextField){
        inputValidation(textInput: rothIRATextField)
    }
    
    @IBAction func individualBrokerageDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: individualBrokerageTextField)
    }
    
    @IBAction func cryptoDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: cryptoTextField)
    }
    
    @IBAction func fourOneKDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: fourOneKTextField)
    }
    
    @IBAction func studentLoansDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: studentLoansTextField)
    }
}

extension AccountsViewController: UITextFieldDelegate {
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

extension AccountsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker {
            return months.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker {
            return months[row]
        } else {
            return years[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthPicker {
            monthFilterTextField.text = String(months[row])
            monthFilterTextField.resignFirstResponder()
        } else {
            yearFilterTextField.text = String(years[row])
            yearFilterTextField.resignFirstResponder()
        }
    }
}
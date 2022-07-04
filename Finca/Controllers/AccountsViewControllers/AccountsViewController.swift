//
//  AccountsViewController.swift
//  Finca
//
//  Created by Joseph Sanchez on 6/15/22.
//

/**
 TODO:
    - Make is so if an accounts document already exists for a selected month and year, pressing "Submit" will update it. Otherwise, it will create a new document for that month and year
    - Ask the user if they want to update the accounts for the month and year, just in case they don't notice they're about to do that
 */
import Foundation
import UIKit
import Firebase
import FirebaseStorage
import SwiftUI

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
    
    var docRef: DocumentReference!
    let db = Firestore.firestore()
    
    private var userId = ""
    private var accountsId = ""
    
    let months = K.months
    var years = K.years
    
    let monthPicker = UIPickerView()
    let yearPicker = UIPickerView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = Auth.auth().currentUser!.uid
        accountsId = UUID().uuidString
        
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
    
    func inputValidation(textInput: UITextField, _ inputEnum: textInputs) {
        let (validation, message): (Bool, String?) = InputValidation.validateField(textInput.text!, inputEnum)
        
        if !validation {
            let dialogMessage = UIAlertController(title: "Error", message: message!, preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default)

            dialogMessage.addAction(ok)

            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func findInfoForDate(completion: @escaping ((Accounts?) -> ())) {
        if monthFilterTextField.text! == "Month" || yearFilterTextField.text! == "Year"{
            print("") //TODO: Add a popup message here telling the user to select the date
        }
        let dateFormatChanger = DateFormatChanger(dateStr: "\(monthFilterTextField.text!.prefix(3)), 0 \(yearFilterTextField.text!)")

        let month = dateFormatChanger.getMonth()
        let year = dateFormatChanger.getYear()

        db.collection(K.UserCollection.collectionName).document(userId).collection(K.AccountCollection.collectionName).whereField("month", isEqualTo: month).whereField("year", isEqualTo: year).getDocuments { querySnapshot, err in
            if let err = err {
                print("THIS DOCUMENT DOES NOT EXIST: ")
                completion(nil)
            } else {
                var count = 0
                for _ in querySnapshot!.documents {
                    count += 1
                }
                if count == 0 {
                    completion(nil)
                } else {
                    let data = querySnapshot!.documents[0].data()
                    let month = data["month"] as! Int
                    let year = data["year"] as! Int
                    let accountsID = data["accountsID"] as! String
                    let emergencyFund = data["emergencyFund"] as! Float
                    let downPaymentFund = data["downPaymentFund"] as! Float
                    let macStudioFund = data["macStudioFund"] as! Float
                    let wellsFargoCheckings = data["wellsFargoCheckings"] as! Float
                    let allyCheckings = data["allyCheckings"] as! Float
                    let rothIRA = data["rothIRA"] as! Float
                    let individualBrokerage = data["individualBrokerage"] as! Float
                    let crypto = data["crypto"] as! Float
                    let fourOneK = data["fourOneK"] as! Float
                    let studentLoans = data["studentLoans"] as! Float
                    let accounts = Accounts(accountsID, month, year, emergencyFund, downPaymentFund, macStudioFund, wellsFargoCheckings, allyCheckings, rothIRA, individualBrokerage, crypto, fourOneK, studentLoans)
                    completion(accounts)
                }
            }
        }
    }
    
    func validateAllFieldsFilled() -> Bool {
        inputValidation(textInput: emergencyFundTextField, .amount)
        inputValidation(textInput: downPaymentTextField, .amount)
        inputValidation(textInput: macStudioFundTextField, .amount)
        inputValidation(textInput: wellsFargoCheckingsTextField, .amount)
        inputValidation(textInput: allyCheckingsTextField, .amount)
        inputValidation(textInput: rothIRATextField, .amount)
        inputValidation(textInput: individualBrokerageTextField, .amount)
        inputValidation(textInput: cryptoTextField, .amount)
        inputValidation(textInput: fourOneKTextField, .amount)
        inputValidation(textInput: studentLoansTextField, .amount)
        inputValidation(textInput: monthFilterTextField, .date)
        inputValidation(textInput: yearFilterTextField, .date)
        
        if self.presentedViewController as? UIAlertController != nil {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func emergencyFundDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: emergencyFundTextField, .amount)
    }
    
    @IBAction func downPaymentDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: downPaymentTextField, .amount)
    }
    
    @IBAction func macStudioFundDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: macStudioFundTextField, .amount)
    }
    
    @IBAction func wellsFargoCheckingsDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: wellsFargoCheckingsTextField, .amount)
    }
    
    @IBAction func allyCheckingsDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: allyCheckingsTextField, .amount)
    }
    
    @IBAction func rothIRADidEndEditing(_ sender: UITextField){
        inputValidation(textInput: rothIRATextField, .amount)
    }
    
    @IBAction func individualBrokerageDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: individualBrokerageTextField, .amount)
    }
    
    @IBAction func cryptoDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: cryptoTextField, .amount)
    }
    
    @IBAction func fourOneKDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: fourOneKTextField, .amount)
    }
    
    @IBAction func studentLoansDidEndEditing(_ sender: UITextField){
        inputValidation(textInput: studentLoansTextField, .amount)
    }
    
    @IBAction func submitAccounts(_ sender: UIButton) {
        findInfoForDate { accountsInfo in
            if let accounts = accountsInfo {
                self.emergencyFundTextField.text = String(accounts.emergencyFund ?? 0.0)
                self.downPaymentTextField.text = String(accounts.downPaymentFund ?? 0.0)
                self.macStudioFundTextField.text = String(accounts.macStudioFund ?? 0.0)
                self.wellsFargoCheckingsTextField.text = String(accounts.wellsFargoCheckings ?? 0.0)
                self.allyCheckingsTextField.text = String(accounts.allyCheckings ?? 0.0)
                self.rothIRATextField.text = String(accounts.rothIRA ?? 0.0)
                self.individualBrokerageTextField.text = String(accounts.individualBrokerage ?? 0.0)
                self.cryptoTextField.text = String(accounts.crypto ?? 0.0)
                self.fourOneKTextField.text = String(accounts.fourOneK ?? 0.0)
                self.studentLoansTextField.text = String(accounts.studentLoans ?? 0.0)
            } else {
                self.emergencyFundTextField.text = ""
                self.downPaymentTextField.text = ""
                self.macStudioFundTextField.text = ""
                self.wellsFargoCheckingsTextField.text = ""
                self.allyCheckingsTextField.text = ""
                self.rothIRATextField.text = ""
                self.individualBrokerageTextField.text = ""
                self.cryptoTextField.text = ""
                self.fourOneKTextField.text = ""
                self.studentLoansTextField.text = ""
                
                let message = "Accounts info does not exist for that date, please try another date or submit account info for that date"
                let dialogMessage = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

                let ok = UIAlertAction(title: "OK", style: .default)

                dialogMessage.addAction(ok)

                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        
//        let monthsFilled = monthFilterTextField.text! != "Month" || yearFilterTextField.text! != "Year"
//        let fieldsFilled = validateAllFieldsFilled()
//        if(!monthsFilled || !fieldsFilled){
//            print("Fields were not filled")
//            return
//        }
//        let dateFormatChanger = DateFormatChanger(dateStr: "\(monthFilterTextField.text!.prefix(3)), 0 \(yearFilterTextField.text!)")
//
//        let month = dateFormatChanger.getMonth()
//        let year = dateFormatChanger.getYear()
//
//        guard let emergencyFund = Float(emergencyFundTextField.text!) else { return }
//        guard let downPaymentFund = Float(downPaymentTextField.text!) else { return }
//        guard let macStudioFund = Float(macStudioFundTextField.text!) else { return }
//        guard let wellsFargoCheckings = Float(wellsFargoCheckingsTextField.text!) else { return }
//        guard let allyCheckings = Float(allyCheckingsTextField.text!) else { return }
//        guard let rothIRA = Float(rothIRATextField.text!) else { return }
//        guard let individualBrokerage = Float(individualBrokerageTextField.text!) else { return }
//        guard let crypto = Float(cryptoTextField.text!) else { return }
//        guard let fourOneK = Float(fourOneKTextField.text!) else { return }
//        guard let studentLoans = Float(studentLoansTextField.text!) else { return }

//        docRef = Firestore.firestore().document("\(K.UserCollection.collectionName)/\(userId)/\(K.AccountCollection.collectionName)/\(accountsId)")
//
//        let dataToSave: [String: Any] = ["accountsID": accountsId, "month": month, "year": year, "emergencyFund": emergencyFund, "downPaymentFund": downPaymentFund, "macStudioFund": macStudioFund, "wellsFargoCheckings": wellsFargoCheckings, "allyCheckings": allyCheckings, "rothIRA": rothIRA, "individualBrokerage": individualBrokerage, "crypto": crypto, "fourOneK": fourOneK, "studentLoans": studentLoans]
//        docRef.setData(dataToSave)
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

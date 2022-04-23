//
//  MonthDateYearDelegates.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/23/22.
//

import Foundation
import UIKit

class MonthPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    let months = ["January", "February", "March", "April",
                  "May", "June", "July", "August",
                  "September", "October","November", "December"]
    let monthTxtField: UITextField
    
    init(_ monthTxtField: UITextField){
        self.monthTxtField = monthTxtField
    }
    
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
        monthTxtField.text = String(months[row])
        monthTxtField.resignFirstResponder()
    }
}

//TODO: Make it so that you can change the amount of days depending on the month
class DayPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    let days: [Int] = (0...31).map {Int(String($0))!}
    let dayTxtField: UITextField

    init(_ dayTxtField: UITextField){
        self.dayTxtField = dayTxtField
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(days[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dayTxtField.text = String(days[row])
        dayTxtField.resignFirstResponder()
    }
}

class YearPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
    let years: [Int] = (2020...Calendar.current.component(.year, from: Date())).map {Int(String($0))!}
    let yearTxtField: UITextField

    init(_ dayTxtField: UITextField){
        self.yearTxtField = dayTxtField
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearTxtField.text = String(years[row])
        yearTxtField.resignFirstResponder()
    }
}

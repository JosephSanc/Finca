//
//  MonthDateYearDelegates.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/23/22.
//

import Foundation
import UIKit

class MonthPickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    let months: [String]
    let monthTxtField: UITextField
    
    init(_ months: [String], _ monthTxtField: UITextField){
        self.months = months
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
    let days: [Int]
    let dayTxtField: UITextField

    init(_ days: [Int], _ dayTxtField: UITextField){
        self.days = days
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
    let years: [Int]
    let yearTxtField: UITextField

    init(_ years: [Int], _ dayTxtField: UITextField){
        self.years = years
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

//
//  DateHelper.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/22/22.
//

import Foundation

struct DateHelper {
    func getMonthStr(_ monthNum: Int) -> String{
        let monthMap: [Int: String] = [1: "January", 2: "February", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]
        return monthMap[monthNum]!
    }
    
    func getMonthNum(_ monthStr: String) -> Int{
        let monthMap: [String: Int] = ["January": 1, "February": 2, "March": 3, "April": 4, "May": 5, "June": 6, "July": 7, "August": 8, "September": 9, "October": 10, "November": 11, "December": 12]
        if let monthNum = monthMap[monthStr] {
            return monthNum
        } else {
            print("ERROR: MonthStr = \(monthStr)")
            return -1
        }
    }
    
    func isLeapYear(_ year: Int) -> Bool {
        
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        
        return isLeapYear
    }
}

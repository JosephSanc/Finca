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
    
    func isLeapYear(_ year: Int) -> Bool {
        
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        
        return isLeapYear
    }
}

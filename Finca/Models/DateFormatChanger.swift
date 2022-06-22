//
//  DateHelper.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/16/22.
//

import Foundation

struct DateFormatChanger {
    
    private let splitDate: [String.SubSequence]
    
    init(dateStr: String){
        splitDate = dateStr.replacingOccurrences(of: ",", with: "").split(separator: " ")
    }
    
    func getMonth() -> Int{
        let monthMap: [String: Int] = ["Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "June": 6, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12]
        return monthMap[String(splitDate[0])]!
    }

    func getDay() -> Int{
        return Int(splitDate[1])!
    }
    
    func getYear() -> Int{
        return Int(splitDate[2])!
    }
    
}

//
//  DateHelper.swift
//  Finca
//
//  Created by Joseph Sanchez on 4/16/22.
//

import Foundation

struct DateHelper {
    public static func getMonthNumber(monthStr: String) -> Int{
        let monthMap: [String: Int] = ["Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12]
        return monthMap[monthStr]!
    }
}

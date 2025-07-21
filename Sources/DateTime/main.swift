//
//  main.swift
//  ExperimentsEverything
//
//  Created by Anbalagan on 19/06/25.
//

import Foundation

///`gregorian` Calendar by default weekday start from `Sunday`
let calendar = Calendar.current

///`iso8601` Calendar by default weekday start from `Monday`
//let calendar = Calendar(identifier: .iso8601)

// Get week number from given date
let yearFirstDate = calendar.date(
    from: DateComponents(
        timeZone: TimeZone(secondsFromGMT: 0),
        year: 2025,
        month: 12,
        day: 31
    )
)

let weekOfYear = calendar.component(.weekOfYear, from: yearFirstDate!)
//let firstWeekDay = calendar.firstWeekday
print(yearFirstDate ?? "")

//
//  Date.swift
//
//
//  Created by Yugo Sugiyama on 2023/10/08.
//

import Foundation

public extension Date {
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    var isTommorow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }

    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }

    func offsetDays(offset: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: offset, to: self)
    }

    func offsetHours(offset: Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: offset, to: self)
    }

    func offsetSeconds(offset: Int) -> Date? {
            return Calendar.current.date(byAdding: .second, value: offset, to: self)
        }

    func isBetween(_ startDate: Date, endDate: Date) -> Bool {
        return (min(startDate, endDate) ... max(startDate, endDate)).contains(self)
    }

    func isSamePeriod(baseDate: Date, targetDate: Date, startingHour: Int, offsetDay: Int) -> Bool {
        let startDate = Calendar.current.date(bySettingHour: startingHour, minute: 0, second: 0, of: baseDate)!
        let endDate = Calendar.current.date(bySettingHour: startingHour, minute: 0, second: 0, of: baseDate)!
            .offsetDays(offset: offsetDay)!
        return targetDate.isBetween(startDate, endDate: endDate)
    }

    func setTime(hour: Int, minute: Int, second: Int) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.hour = hour
        components.minute = minute
        components.second = second

        return calendar.date(from: components)
    }
}

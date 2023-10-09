//
//  ToiletResult.swift
//
//
//  Created by Yugo Sugiyama on 2023/10/02.
//

import Foundation

public enum DeviceType: String, Codable, CaseIterable, Identifiable {
    case watch
    case phone
    case widget

    public var id: String {
        return rawValue
    }
}

public enum ToiletType: String, Codable, CaseIterable, Identifiable {
    case big
    case small

    public var id: String {
        return rawValue
    }

    public var displayText: String {
        switch self {
        case .big: return "💩"
        case .small: return "💦"
        }
    }
}

public struct ToiletResultItem: Codable, Identifiable, Equatable {
    public let id: String
    public let toiletType: ToiletType
    public let date: Date
    public let deviceType: DeviceType

    public init(toiletType: ToiletType, date: Date, deviceType: DeviceType) {
        id = UUID().uuidString
        self.toiletType = toiletType
        self.date = date
        self.deviceType = deviceType
    }
}

public extension Array where Element == ToiletResultItem {
    func asToiletResultConverted(startingHour: Int) -> [ToiletResult] {
        let sortedItems = sorted(by: \.date, order: .ascending)
        var tempResults: [ToiletResult] = []
        var tempItems: [ToiletResultItem] = []
        var currentDate: Date?

        func addItemsToResults() {
            if !tempItems.isEmpty {
                tempResults.append(.init(items: tempItems.sorted(by: \.date, order: .ascending)))
            }
        }

        sortedItems.forEach { item in
            if currentDate == nil {
                currentDate = item.date
            }
            let tempCurrentDate = currentDate ?? item.date

            let startDate = tempCurrentDate.setTime(hour: startingHour, minute: 0, second: 0)!
            let endDate = startDate.offsetDays(offset: 1)!.offsetSeconds(offset: -1)!

            if !item.date.isBetween(startDate, endDate: endDate) {
                addItemsToResults()
                tempItems = []
                currentDate = item.date
            } else {
                
            }
            tempItems.append(item)
        }
        addItemsToResults()

        return tempResults.sorted(by: \.firstItemDate, order: .descending)
    }
}

public struct ToiletResult: Codable, Identifiable, Equatable {
    public let id: String
    public let items: [ToiletResultItem]
    fileprivate var firstItemDate: Date {
        items.first?.date ?? Date()
    }
    public var displayDateString: String {
        if firstItemDate.isToday {
            return "今日"
        } else if firstItemDate.isYesterday {
            return "昨日"
        } else if firstItemDate.isTommorow {
            return "明日"
        } else {
            return firstItemDate.asString(withFormat: .dateWithWeekDayNoZero, locale: .jp)
        }
    }

    public var sectionDisplayValue: String {
        let smallCount = items.filter({ $0.toiletType == .small }).count
        let bigCount = items.filter({ $0.toiletType == .big }).count
        return "\(ToiletType.small.displayText): \(smallCount)回, \(ToiletType.big.displayText): \(bigCount)回"
    }

    public init(items: [ToiletResultItem]) {
        id = UUID().uuidString
        self.items = items
    }
}

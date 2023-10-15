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

public enum ToiletType: Codable, Identifiable, Equatable {
    public enum ToiletBigType: String, Codable, CaseIterable, Identifiable {
        case hard = "硬め"
        case soft = "軟かめ"
        case liquid = "下痢"
        public static let `default` = ToiletType.ToiletBigType.hard

        public var id: String {
            return rawValue
        }
    }

    case big(type: ToiletBigType)
    case small

    public var displayText: String {
        switch self {
        case .big(let type):
            return "\(displayIconString)(\(type.rawValue))"
        case .small:
            return displayIconString
        }
    }

    public var displayIconString: String {
        switch self {
        case .big: return "💩"
        case .small: return "💦"
        }
    }

    public var isBig: Bool {
        switch self {
        case .big: return true
        case .small: return false
        }
    }

    public var id: String {
        switch self {
        case .big(let type):
            type.id
        case .small:
            displayIconString
        }
    }

    public func bigTypeChanged(type: ToiletBigType) -> ToiletType {
        switch self {
        case .big:
            return .big(type: type)
        case .small:
            return self
        }
    }
}

public struct ToiletResultItem: Codable, Identifiable, Equatable {
    public let id: String
    public let toiletType: ToiletType
    public let date: Date
    public let deviceType: DeviceType
    
    public init(id: String? = nil, toiletType: ToiletType, date: Date, deviceType: DeviceType) {
        self.id = id ?? UUID().uuidString
        self.toiletType = toiletType
        self.date = date
        self.deviceType = deviceType
    }

    public static var mocks: [ToiletResultItem] {
        return [
            ToiletResultItem(toiletType: .small, date: Date().offsetHours(offset: -14)!, deviceType: .phone),
            ToiletResultItem(toiletType: .big(type: .hard), date: Date().offsetHours(offset: -8)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetHours(offset: -4)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date(), deviceType: .phone),

            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -1)!.offsetHours(offset: -14)!, deviceType: .phone),
            ToiletResultItem(toiletType: .big(type: .hard), date: Date().offsetDays(offset: -1)!.offsetHours(offset: -8)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -1)!.offsetHours(offset: -4)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -1)!, deviceType: .phone),


            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -2)!.offsetHours(offset: -14)!, deviceType: .phone),
            ToiletResultItem(toiletType: .big(type: .hard), date: Date().offsetDays(offset: -2)!.offsetHours(offset: -8)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -2)!.offsetHours(offset: -4)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -2)!, deviceType: .phone),


            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -3)!.offsetHours(offset: -14)!, deviceType: .phone),
            ToiletResultItem(toiletType: .big(type: .hard), date: Date().offsetDays(offset: -3)!.offsetHours(offset: -8)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -3)!.offsetHours(offset: -4)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -3)!, deviceType: .phone),


            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -4)!.offsetHours(offset: -14)!, deviceType: .phone),
            ToiletResultItem(toiletType: .big(type: .hard), date: Date().offsetDays(offset: -4)!.offsetHours(offset: -8)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -4)!.offsetHours(offset: -4)!, deviceType: .phone),
            ToiletResultItem(toiletType: .small, date: Date().offsetDays(offset: -4)!, deviceType: .phone),
        ]
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
        let bigCount = items.filter({ $0.toiletType.isBig }).count
        return "\(ToiletType.small.displayIconString): \(smallCount)回, \(ToiletType.big(type: .hard).displayIconString): \(bigCount)回"
    }

    public var sectionDisplayValueWithTimeRange: String {
        let smallCount = items.filter({ $0.toiletType == .small }).count
        let bigCount = items.filter({ $0.toiletType.isBig }).count
        let firstItemDateAdjusted = firstItemDate.setTime(hour: SharedDefaults.startDayTime, minute: 0, second: 0)!
        let recordTimeRange = "\(firstItemDateAdjusted.asString(withFormat: .timeHourNoZero))~\(firstItemDateAdjusted.offsetDays(offset: 1)!.offsetSeconds(offset: -1)!.asString(withFormat: .timeHourNoZero))"
        return "\(ToiletType.small.displayIconString): \(smallCount)回, \(ToiletType.big(type: .hard).displayIconString): \(bigCount)回(\(recordTimeRange))"
    }

    public init(items: [ToiletResultItem]) {
        id = UUID().uuidString
        self.items = items
    }
}

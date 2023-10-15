import XCTest
import Testing
@testable import ToiletCheckInCore

final class AllTests: XCTestCase {
  func testAll() async {
    await XCTestScaffold.runAllTests(hostedBy: self)
  }
}

actor ToiletCheckInCoreLogicTests {
    init() {}

    deinit {}

    // Test to check isBetween func of `Date` extension
    @Test func checkIsBetweenLogic() {
        let startDate = Date(timeIntervalSince1970: 1) // 1970年1月1日 00:00:01
        let endDate = Date(timeIntervalSince1970: 60)

        let targetDate1 = startDate
        #expect(targetDate1.isBetween(startDate, endDate: endDate))
        let targetDate2 = Date(timeIntervalSince1970: 2)
        #expect(targetDate2.isBetween(startDate, endDate: endDate))

        let targetDate3 = endDate
        #expect(targetDate3.isBetween(startDate, endDate: endDate))
        let targetDate4 = Date(timeIntervalSince1970: 59)
        #expect(targetDate4.isBetween(startDate, endDate: endDate))

        let targetDate5 = Date(timeIntervalSince1970: 0)
        #expect(!targetDate5.isBetween(startDate, endDate: endDate))
        let targetDate6 = Date(timeIntervalSince1970: 61)
        #expect(!targetDate6.isBetween(startDate, endDate: endDate))

        let startDate2 = Date(timeIntervalSince1970: 0).offsetHours(offset: 6)! // 1970年1月1日 06:00:00
        let endDate2 = startDate2.offsetDays(offset: 1)! // 1970年1月2日 06:00:00

        let targetDate7 = startDate2.offsetHours(offset: 3)! // 1970年1月1日 09:00:00
        #expect(targetDate7.isBetween(startDate2, endDate: endDate2))
        let targetDate8 = endDate2.offsetHours(offset: -3)!
        #expect(targetDate8.isBetween(startDate2, endDate: endDate2))
        let targetDate9 = endDate2.offsetHours(offset: 3)!
        #expect(!targetDate9.isBetween(startDate2, endDate: endDate2))
    }

    @Test func checkAsToiletResultConvertedLogic() {
        let startingHour = 6

        let date = Date()
        let date1 = date.setTime(hour: 5, minute: 0, second: 0)!
        let item1 = ToiletResultItem(toiletType: .big(type: .default), date: date1, deviceType: .phone)
        let date2 = date.setTime(hour: startingHour, minute: 0, second: 0)!
        let item2 = ToiletResultItem(toiletType: .big(type: .default), date: date2, deviceType: .watch)
        let date3 = date.setTime(hour: 12, minute: 0, second: 0)!
        let item3 = ToiletResultItem(toiletType: .small, date: date3, deviceType: .widget)
        let date4 = date.setTime(hour: 15, minute: 0, second: 0)!.offsetDays(offset: -1)!
        let item4 = ToiletResultItem(toiletType: .small, date: date4, deviceType: .phone)

        let items = [item4, item3, item2, item1]
        let results = items.asToiletResultConverted(startingHour: startingHour)
        results.forEach { result in
            print("Result: \(result.sectionDisplayValue), count: \(result.items.count)")
            result.items.forEach { item in
                print(" Item: \(item.toiletType), \(item.deviceType), \(item.date)")
            }
        }

        #expect(results.count == 2)
        
        // must be item2 & item3
        #expect(results[0].items.count == 2)
        #expect(results[0].items[0].toiletType == .big(type: .default) && results[0].items[0].deviceType == .watch)
        #expect(results[0].items[1].toiletType == .small && results[0].items[1].deviceType == .widget)

        // must be item1 & item4
        #expect(results[1].items.count == 2)
        #expect(results[1].items[0].toiletType == .small && results[1].items[0].deviceType == .phone)
        #expect(results[1].items[1].toiletType == .big(type: .default) && results[1].items[1].deviceType == .phone)
    }
}

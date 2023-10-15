//
//  SharedDefaults.swift
//
//
//  Created by Yugo Sugiyama on 2023/10/02.
//

import Foundation

public enum SharedDefaults {
    enum Keys: String {
        case jsonKey = "toiletChechInKey"
        case selectedBigType
        case startDayTime
        case shouldShowCheckmark
    }
    // Ref: https://developer.apple.com/forums/thread/51348?page=2#:~:text=Replies-,Hi%2C%20everyone!,-I%20have%20also
//    public static let groupId = "669226BDWM.group.yugo.sugiyama.toiletChechIn"
    public static let groupId = "group.yugo.sugiyama.toiletCheckIn"
    private static let sharedDefaults = UserDefaults(suiteName: Self.groupId)
    //    private static let sharedDefaults = UserDefaults(suiteName: "group.toiletChechIn.yugo.sugiyama")

    private static let fileName = "data.json"

    public static var selectedBigType: ToiletType.ToiletBigType {
        get {
            guard let string = sharedDefaults?.string(forKey: Keys.selectedBigType.rawValue),
                  let type = ToiletType.ToiletBigType(rawValue: string) else { return .default }
            return type
        }
        set {
            sharedDefaults?.set(newValue.rawValue, forKey: Keys.selectedBigType.rawValue)
        }
    }
    public static var startDayTime: Int {
        get {
            return sharedDefaults?.integer(forKey: Keys.startDayTime.rawValue) ?? 0
        }
        set {
            sharedDefaults?.set(newValue, forKey: Keys.startDayTime.rawValue)
        }
    }
    public static var shouldShowCheckmark: Bool {
        get {
            return sharedDefaults?.bool(forKey: Keys.shouldShowCheckmark.rawValue) ?? false
        }
        set {
            sharedDefaults?.set(newValue, forKey: Keys.shouldShowCheckmark.rawValue)
        }
    }

    public static var toiletResults: [ToiletResultItem] {
        get {
            //            guard let jsonData = sharedDefaults?.string(forKey: key)?.data(using: .utf8) else {
            //                print("Failed to get shared defaults data")
            //                return []
            //            }
            //
            //            let decoder = JSONDecoder()
            //            decoder.dateDecodingStrategy = .iso8601
            //
            //            do {
            //                return try decoder.decode([ToiletResult].self, from: jsonData)
            //            } catch {
            //                print("Error decoding JSON: \(error)")
            //                return []
            //            }
            let fileManager = FileManager.default
            guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Self.groupId) else {
                print("Could not get the App Group container URL")
                return []
            }

            let fileURL = groupURL.appendingPathComponent(Self.fileName)

            do {
                let jsonData = try Data(contentsOf: fileURL)
                let results = try JSONDecoder().decode([ToiletResultItem].self, from: jsonData)
                return results
            } catch {
                print("Error loading data: \(error)")
                return []
            }
        }

        set {
            let fileManager = FileManager.default
            guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Self.groupId) else {
                print("Could not get the App Group container URL")
                return
            }
            let fileURL = groupURL.appendingPathComponent(Self.fileName)

            do {
                let jsonData = try JSONEncoder().encode(newValue)
                try jsonData.write(to: fileURL)
            } catch {
                print("Error saving data: \(error)")
            }
            //            let encoder = JSONEncoder()
            //            encoder.dateEncodingStrategy = .iso8601
            //
            //            do {
            //                let jsonData = try encoder.encode(newValue)
            //                guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            //                    print("Failed to convert data to String")
            //                    return
            //                }
            //                sharedDefaults?.set(jsonString, forKey: key)
            //            } catch {
            //                print("Error encoding to JSON: \(error)")
            //            }
        }
    }

    public static func clear() {
        toiletResults = []
    }

    public static func add(item: ToiletResultItem) {
        var results = SharedDefaults.toiletResults
        results.append(item)
        SharedDefaults.toiletResults = results
    }

    public static func remove(item: ToiletResultItem) {
        var results = SharedDefaults.toiletResults
        results.removeAll(where: { $0.id == item.id })
        SharedDefaults.toiletResults = results
    }

    public static func update(item: ToiletResultItem) {
        remove(item: item)
        add(item: item)
    }
}

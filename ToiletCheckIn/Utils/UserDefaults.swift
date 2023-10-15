//
//  UserDefaults.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//


import Foundation
import ToiletCheckInCore

enum UserDefaultsKey: String {
    case fontSizeType
    case isMockEnable
}

extension UserDefaults {
    var fontSizeType: FontSizeType {
        get {
            let fontSize = double(forKey: UserDefaultsKey.fontSizeType.rawValue)
            return FontSizeType(rawValue: fontSize) ?? .m
        }
        set {
            setValue(newValue.rawValue, forKey: UserDefaultsKey.fontSizeType.rawValue)
        }
    }

    var isMockEnable: Bool {
        get {
            return bool(forKey: UserDefaultsKey.isMockEnable.rawValue)
        }
        set {
            setValue(newValue, forKey: UserDefaultsKey.isMockEnable.rawValue)
        }
    }
}


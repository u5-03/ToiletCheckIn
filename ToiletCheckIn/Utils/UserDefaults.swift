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
}


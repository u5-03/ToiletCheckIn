//
//  Font.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI

extension Font {
    static func system(type: FontSizeType, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        return .system(size: type.rawValue, weight: weight, design: design)
    }
}

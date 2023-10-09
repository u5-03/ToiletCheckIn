//
//  ToiletCheckInWidgetBundle.swift
//  ToiletCheckInWidget
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import WidgetKit
import SwiftUI

@main
struct ToiletCheckInWidgetBundle: WidgetBundle {
    var body: some Widget {
        ToiletCheckInWidget()
        ToiletCheckInWidgetLiveActivity()
    }
}

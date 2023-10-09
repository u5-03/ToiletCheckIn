//
//  AppState.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI
import Observation

@Observable
final class AppState {
    var fontSizeType: FontSizeType = UserDefaults.standard.fontSizeType
}

struct CustomEnvironmentKey: EnvironmentKey {
    static var defaultValue = AppState()

}

extension EnvironmentValues {
    // 1
    var appState: AppState {

        get { self[CustomEnvironmentKey.self] }
        set { self[CustomEnvironmentKey.self] = newValue }
    }
}

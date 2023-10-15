//
//  ContentView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/02.
//

import SwiftUI
import ToiletCheckInCore
import WidgetKit

struct ContentView: View {
    @State private var appState = AppState()
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        ToiletCheckInListView()
            .environment(\.appState, appState)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    SharedDefaults.shouldShowCheckmark = false
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
    }
}

#Preview {
    ContentView()
}


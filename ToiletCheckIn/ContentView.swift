//
//  ContentView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/02.
//

import SwiftUI
import ToiletCheckInCore

struct ContentView: View {
    @State private var appState = AppState()

    var body: some View {
        ToiletCheckInListView()
            .environment(\.appState, appState)
    }
}

#Preview {
    ContentView()
}


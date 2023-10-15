//
//  ContentView.swift
//  ToiletCheckInWatchApp Watch App
//
//  Created by Yugo Sugiyama on 2023/10/15.
//

import SwiftUI
import ToiletCheckInCore

struct ContentView: View {
    @State private var watchDataHandler = WatchDataHandler()

    var body: some View {
        ToiletCheckInButtonView(deviceType: .watch) { type in
            watchDataHandler.send(toiletType: type)
        }
    }
}

#Preview {
    ContentView()
}

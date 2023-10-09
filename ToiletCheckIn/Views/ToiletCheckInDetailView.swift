//
//  ToiletCheckInDetailView.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import SwiftUI
import ToiletCheckInCore

struct ToiletCheckInDetailView: View {
    @Environment(\.appState) private var appState
    let result: ToiletResult

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(content: {
                    ForEach(result.items) { item in
                        HStack {
                            Text(item.date.asString(withFormat: .dateTimeWithWeekDayNoZero, locale: .jp))
                                .font(.system(type: appState.fontSizeType))
                            Spacer()
                            Text(item.toiletType.displayText)
                                .font(.system(type: appState.fontSizeType))
                        }
                    }
                }, header: {
                    Text(result.sectionDisplayValue)
                    // Ref: https://stackoverflow.com/a/71914266
                        .multilineTextAlignment(.leading)
                        .font(.system(type: appState.fontSizeType))
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                })
            }
        }
        .navigationTitle("\(result.displayDateString)のトイレの記録")
    }
}

#Preview {
    ToiletCheckInDetailView(result: .init(items: [
        .init(toiletType: .big, date: Date(), deviceType: .phone),
        .init(toiletType: .small, date: Date().offsetHours(offset: -3)!, deviceType: .widget),
    ]))
        .environment(AppState())
}

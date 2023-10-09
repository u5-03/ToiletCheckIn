//
//  ToiletCheckInWidget.swift
//  ToiletCheckInWidget
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import WidgetKit
import SwiftUI
import ToiletCheckInCore
import AppIntents

struct ToiletSmallIntent: AppIntent {
    static var title: LocalizedStringResource = "Small"

    func perform() async throws -> some IntentResult {
        let item = ToiletResultItem(toiletType: .small, date: Date(), deviceType: .widget)
        let key = Date().asString(withFormat: .dateWithWeekDayNoZero, locale: .jp)
        SharedDefaultsManager.add(item: item)
        return .result()
    }
}

struct ToiletBigIntent: AppIntent {
    static var title: LocalizedStringResource = "Big"

    func perform() async throws -> some IntentResult {
        let item = ToiletResultItem(toiletType: .big, date: Date(), deviceType: .widget)
        let key = Date().asString(withFormat: .dateWithWeekDayNoZero, locale: .jp)
        SharedDefaultsManager.add(item: item)
        return .result()
    }
}


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct ToiletCheckInWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("チェックイン")
                .font(.system(size: 16, weight: .bold))
            HStack {
                Spacer()
                Button(intent: ToiletBigIntent()) {
                    Text(ToiletType.big.displayText)
                        .font(.system(size: 28))
                }
                Spacer()
                Button(intent: ToiletSmallIntent()) {
                    Text(ToiletType.small.displayText)
                        .font(.system(size: 28))
                }
                Spacer()
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct ToiletCheckInWidget: Widget {
    let kind: String = "ToiletCheckInWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ToiletCheckInWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("トイレチェックイン")
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    ToiletCheckInWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

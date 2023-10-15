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
        SharedDefaults.add(item: item)
        withAnimation {
            SharedDefaults.shouldShowCheckmark = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SharedDefaults.shouldShowCheckmark = false
        }
        return .result()
    }
}

struct ToiletBigIntent: AppIntent {
    static var title: LocalizedStringResource = "Big"

    func perform() async throws -> some IntentResult {
        let item = ToiletResultItem(toiletType: .big(type: SharedDefaults.selectedBigType), date: Date(), deviceType: .widget)
        SharedDefaults.add(item: item)
        withAnimation {
            SharedDefaults.shouldShowCheckmark = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            SharedDefaults.shouldShowCheckmark = false
        }
        return .result()
    }
}


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), shouldShowCheck: SharedDefaults.shouldShowCheckmark, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), shouldShowCheck: SharedDefaults.shouldShowCheckmark, configuration: configuration)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 0, to: currentDate)!

        let entries: [SimpleEntry] = [
            SimpleEntry(date: entryDate, shouldShowCheck: SharedDefaults.shouldShowCheckmark, configuration: configuration)
        ]
//        for hourOffset in 0 ..< 5 {
//
//            entries.append(entry)
//        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let shouldShowCheck: Bool
    let configuration: ConfigurationAppIntent
}

struct ToiletCheckInWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack() {
            Spacer()
            HStack(spacing: 4) {
                Text("チェックイン")
                    .font(.system(size: 16, weight: .bold))
                Group {
                    if SharedDefaults.shouldShowCheckmark {
                        Image(systemName: "checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 16, height: 16)
            }
            Spacer()
            HStack {
                Spacer()
                Button(intent: ToiletBigIntent()) {
                    Text(ToiletType.big(type: .default).displayIconString)
                        .font(.system(size: 28))
                }
                Spacer()
                Button(intent: ToiletSmallIntent()) {
                    Text(ToiletType.small.displayIconString)
                        .font(.system(size: 28))
                }
                Spacer()
            }
            Spacer()
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct ToiletCheckInWidget: Widget {
    static let kind: String = "ToiletCheckInWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: Self.kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
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
    SimpleEntry(date: .now, shouldShowCheck: true, configuration: .smiley)
    SimpleEntry(date: .now, shouldShowCheck: false, configuration: .starEyes)
}

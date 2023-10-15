//
//  ToiletCheckInWatchWidget.swift
//  ToiletCheckInWatchWidget
//
//  Created by Yugo Sugiyama on 2023/10/15.
//

import WidgetKit
import SwiftUI

// Ref: https://lyvennithasasikumar.medium.com/complications-widgets-for-watchos-swiftui-99bf176231a8
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: Image("Circular"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: Image("Circular"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let uiImage = UIImage(named: "Circular")!
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, image: Image(uiImage: uiImage))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: Image
}

struct ToiletCheckInWatchWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // pngなどだと、loadされない
        Image("Image")
            .resizable()
            .padding()
            .background(Color.white)
    }
}

@main
struct ToiletCheckInWatchWidget: Widget {
    let kind: String = "ToiletCheckInWatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                ToiletCheckInWatchWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ToiletCheckInWatchWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("トイレチェックイン")
        .description("トイレについての記録を残すアプリ")
        .supportedFamilies([
            .accessoryCircular
        ])
    }
}

#Preview(as: .accessoryCircular) {
    ToiletCheckInWatchWidget()
} timeline: {
    SimpleEntry(date: .now, image: Image("Circular"))
    SimpleEntry(date: .now, image: Image("Circular"))
}

//
//  ToiletCheckInWidgetLiveActivity.swift
//  ToiletCheckInWidget
//
//  Created by Yugo Sugiyama on 2023/10/09.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ToiletCheckInWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ToiletCheckInWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ToiletCheckInWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ToiletCheckInWidgetAttributes {
    fileprivate static var preview: ToiletCheckInWidgetAttributes {
        ToiletCheckInWidgetAttributes(name: "World")
    }
}

extension ToiletCheckInWidgetAttributes.ContentState {
    fileprivate static var smiley: ToiletCheckInWidgetAttributes.ContentState {
        ToiletCheckInWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ToiletCheckInWidgetAttributes.ContentState {
         ToiletCheckInWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ToiletCheckInWidgetAttributes.preview) {
   ToiletCheckInWidgetLiveActivity()
} contentStates: {
    ToiletCheckInWidgetAttributes.ContentState.smiley
    ToiletCheckInWidgetAttributes.ContentState.starEyes
}

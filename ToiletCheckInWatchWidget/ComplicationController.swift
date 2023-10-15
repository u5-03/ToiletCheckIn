//
//  ComplicationController.swift
//  ToiletCheckInWatchApp Watch App
//
//  Created by Yugo Sugiyama on 2023/10/15.
//

import Foundation
import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
        if let template = getComplicationTemplate(for: complication, using: Date()) {
            return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        } else {
            return nil
        }
    }

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        switch complication.family {
        case .graphicCircular:
            let template = getComplicationTemplate(for: complication, using: Date())
            handler(template)
        default:
            handler(nil)
        }
    }

    private func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
        switch complication.family {
        case .circularSmall:
            return CLKComplicationTemplateGraphicCircularView(Image("Circular"))
        default:
            return nil
        }
    }
}

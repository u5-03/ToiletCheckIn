//
//  WatchDataHandler.swift
//  ToiletCheckIn
//
//  Created by Yugo Sugiyama on 2023/10/15.
//

import Foundation
import WatchConnectivity
import Observation
import Combine

public final class WatchDataHandler: NSObject {
    private let key = "ToiletTypeKey"
    public let subject = PassthroughSubject<ToiletResultItem, Never>()

    public override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

public extension WatchDataHandler {
    func send(toiletType: ToiletType) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage([
                key: toiletType.isBig
            ], replyHandler: nil)
        }
    }
}

extension WatchDataHandler: WCSessionDelegate {
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {}

    public func sessionDidDeactivate(_ session: WCSession) {}
#endif

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let isBigType = message[key] as? Bool else { fatalError() }
        let toiletType: ToiletType = if isBigType {
            .big(type: SharedDefaults.selectedBigType)
        } else {
            .small
        }
        let item = ToiletResultItem(
            toiletType: toiletType,
            date: Date(), deviceType: .widget
        )
        SharedDefaults.add(item: item)
        subject.send(item)
    }
}

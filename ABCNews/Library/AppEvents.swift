//
//  Copyright © 2020 NetTrinity - Wael Saad. All rights reserved.
//

import Foundation
import UIKit

public enum AppEventType {
    case didFinishLaunching
    case willEnterForeground
    case didEnterBackground
    case willResignActive
    case didBecomeActive
    case didReceiveMemoryWarning
    case willTerminate
    case significantTimeChange
    case backgroundRefreshStatusDidChange
    case avPlayerItemDidPlayToEndTime

    fileprivate static let eventTypes: [NSNotification.Name: AppEventType] = [
        UIApplication.didFinishLaunchingNotification: .didFinishLaunching,
        UIApplication.willEnterForegroundNotification: .willEnterForeground,
        UIApplication.didEnterBackgroundNotification: .didEnterBackground,
        UIApplication.willResignActiveNotification: .willResignActive,
        UIApplication.didBecomeActiveNotification: .didBecomeActive,
        UIApplication.didReceiveMemoryWarningNotification: .didReceiveMemoryWarning,
        UIApplication.willTerminateNotification: .willTerminate,
        UIApplication.significantTimeChangeNotification: .significantTimeChange,
    ]

    public var notificationName: NSNotification.Name? {
        return type(of: self).eventTypes
            .compactMap { $0.1 == self ? $0.0 : nil }
            .first ?? nil
    }

    public static var allEventTypes: [AppEventType] {
        return eventTypes.values.map { $0 }
    }

    public static var allNotificationNames: [NSNotification.Name] {
        return eventTypes.keys.map { $0 }
    }

    public init?(notificationName name: NSNotification.Name) {
        guard let type = type(of: self).eventTypes[name] else {
            return nil
        }
        self = type
    }
}

public struct AppEvent {
    public let type: AppEventType

    public init?(notification: Foundation.Notification) {
        guard let type = AppEventType(notificationName: notification.name) else {
            return nil
        }
        self.type = type
    }
}

typealias AppEventBlock = (AppEvent) -> Void

protocol AppEventsType {

    func subscribe(_ callBack: @escaping AppEventBlock)
    func dispose()
    func resume()
    func suspend()
}

class AppEvents: AppEventsType {

    fileprivate lazy var nc: NotificationCenter = NotificationCenter.default

    fileprivate var callBack: AppEventBlock?

    fileprivate var enabled: Bool = false

    public init() {
        AppEventType.allNotificationNames.forEach {
            nc.addObserver(self,
                           selector: #selector(AppEvents.notified(_:)),
                           name: $0, object: nil)
        }
    }

    deinit {
        dispose()
        nc.removeObserver(self)
    }

    func subscribe(_ callBack: @escaping AppEventBlock) {
        self.callBack = callBack
        resume()
    }

    func dispose() {
        suspend()
        callBack = nil
    }

    func resume() {
        enabled = true
    }

    func suspend() {
        enabled = false
    }
}

private extension AppEvents {
    @objc func notified(_ notification: Foundation.Notification) {
        if !enabled { return }
        guard let event = AppEvent(notification: notification) else {
            return
        }
        callBack?(event)
    }
}

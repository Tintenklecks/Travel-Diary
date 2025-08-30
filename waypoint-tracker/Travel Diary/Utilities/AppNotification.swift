//

import Combine
import Foundation


class AppNotification {
    let center = NotificationCenter.default

    static let editLocation = Notification.Name("tdEditLocation")
    static let showDetail = Notification.Name("tdShowDetail")
    static let showCompass = Notification.Name("tdShowCompass")
    static let addedEntry = Notification.Name("tdAddedEntry")
    static let updatedEntry = Notification.Name("tdUpdatedEntry")
    static let reloadData = Notification.Name("tdReloadData")


    static func sendEditLocation(entry: DiaryEntryViewModel) {
        send(name: editLocation, entry: entry)
    }

    static func sendShowDetail(entry: DiaryEntryViewModel) {
        send(name: showDetail, entry: entry)
    }

    static func sendShowCompass(entry: DiaryEntryViewModel) {
        send(name: showCompass, entry: entry)
    }

    static func sendReloadData() {
        send(name: reloadData, entry: nil)
    }

    static func send(name: Notification.Name, entry: DiaryEntryViewModel? = nil) {
        let notification = Notification(name: name, object: entry, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
}

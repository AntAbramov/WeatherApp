import UIKit

struct NotificationKey {
    static let selectCityNotification = "select.city"
}

extension Notification.Name {
    static let selectCity = Notification.Name(NotificationKey.selectCityNotification)
}

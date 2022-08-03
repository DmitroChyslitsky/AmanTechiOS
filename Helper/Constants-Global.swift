//
//  Constants-Global.swift
//  Amano
//
//  Created by Alex Murray on 2/12/22.
//

import Foundation

// MARK - Navigation

struct SegueIdentifier {
    static let showSignIn = "showSignIn"
    static let showSignUp = "showSignUp"
    static let showSignUpInfo = "showSignUpInfo"
    static let showTabs = "showTabs"
    static let showProvisioning = "showProvisioning"
    static let showLocationInfo = "showLocationInfo"
}

// Must match tab bar index
enum TabType: Int {
    case home = 0
    case history = 1
    case account = 2
    case actions = 3
}

enum AutoOpenType {
    case editProfile
}

// MARK: - Keychain

struct Keychain {
    static let email = "email"
    static let password = "password"
    static let nonce = "nonce"
}

// MARK: - Misc Constants

struct ReuseIdentifier {
    static let homeHeaderCell = "homeHeaderCell"
    static let homeSubheaderCell = "homeSubheaderCell"
    static let homeTestCell = "homeTestCell"
    static let homeLastTestCell = "homeLastTestCell"
    static let homeNotificationsHeaderCell = "homeNotificationsHeaderCell"
    static let homeNotificationCell = "homeNotificationCell"
}

struct NotificationName {
    static let provisioningDeviceConnectedNotification = Notification.Name("provisioningDeviceConnectedNotification")
    static let provisioningDeviceConnectionFailureNotification = Notification.Name("provisioningDeviceConnectionFailureNotification")
    static let provisioningWifiListFoundNotification = Notification.Name("provisioningWifiListFoundNotification")
    static let provisioningCompletedNotification = Notification.Name("provisioningCompletedNotification")
    static let provisioningWifiConnectionFailureNotification = Notification.Name("provisioningWifiConnectionFailureNotification")
    static let homeRefreshNeeded = Notification.Name("homeRefreshNeeded")
}

struct APIPath {
    static let updateProfile = "updateProfile"
    static let profile = "profile"
    static let assignDevice = "assignDevice/"
    static let updateDecice = "updateDevice"
    static let home = "home"
}

struct Constants {
    static let states = ["Alaska", "Alabama", "Arkansas", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
}

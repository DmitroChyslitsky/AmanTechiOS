//
//  Utility.swift
//  Amano
//
//  Created by Alex Murray on 2/9/22.
//

import ESPProvision

class Utility {
    class func wifiStrengthImage(wifiNetwork: ESPWifiNetwork) -> UIImage? {
        let signalStrength = WifiSignalStrenth.mapRSSI(rssi: wifiNetwork.rssi).rawValue
        let secureText = wifiNetwork.auth == .open ? "insecure" : "secure"
        let imageName = "wifi_\(signalStrength)_\(secureText)"
    
        return UIImage(named: imageName)
    }
    
    class func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    class func showGenericError(text: String? = nil) {
        var title = text ?? "Uh oh. Something went wrong. Please try again"
        DispatchQueue.main.async {
            let topBanner = TopBanner()
            topBanner.configure(type: .failure, title: title)
            topBanner.show()
        }
    }
}

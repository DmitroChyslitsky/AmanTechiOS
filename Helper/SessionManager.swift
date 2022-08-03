//
//  SessionManager.swift
//  Amano
//
//  Created by Alex Murray on 4/4/22.
//

import Foundation
import UIKit

class SessionManager {
    static var shared: SessionManager = SessionManager()
    
    var autoOpenType: AutoOpenType?
    
    var tabBarController: UITabBarController? {
        didSet {
            self.sessionStarted()
        }
    }
    
    // Use this to handle any actions needed on app startup
    private func sessionStarted() {
        
    }
    
    // MARK: - Navigation
    
    func selectTab(type: TabType) {
        self.tabBarController?.selectedIndex = type.rawValue
    }
}

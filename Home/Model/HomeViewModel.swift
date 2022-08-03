//
//  HomeViewModel.swift
//  Amano
//
//  Created by Alex Murray on 2/14/22.
//

import Foundation
import Lottie

enum HomeTableViewCellType: CaseIterable {
    case subheader
    case ph
    case alkalinity
    case bromine
    case freeChlorine
    case combinedChlorine
    case lastTest
    case notificationsHeader
    case notification
    
    static func getTestCellType(testName: TestName) -> HomeTableViewCellType? {
        switch testName {
        case .pH:
            return .ph
        case .alkalinity:
            return .alkalinity
        case .freeChlorine:
            return .freeChlorine
        case .combinedChlorine:
            return .combinedChlorine
        case .bromine:
            return .bromine
        default:
            return nil
        }
    }
}

class HomeViewModel: Codable {
    var firstName: String?
    var lastName: String?
    var phone: String?
    var address: Address?
    var devices: [Device]?
    
    init() {
        self.addCompleteProfileRecommendationIfNeeded()
    }
    
    // MARK: - Codable
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)
        self.address = try values.decodeIfPresent(Address.self, forKey: .address)
        self.devices = try values.decodeIfPresent([Device].self, forKey: .devices)
        self.addCompleteProfileRecommendationIfNeeded()
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case phone
        case address
        case devices
    }
    
    // MARK: - Helper
    
    private var cells = [HomeTableViewCellType]()
    
    func getTableViewCells() -> [HomeTableViewCellType] {
        var cells = [HomeTableViewCellType.subheader]
        if let device = self.devices?.first {
            // Tests
            if let tests = device.measurements?.tests {
                for test in tests {
                    if let testName = test.testName, let testCell = HomeTableViewCellType.getTestCellType(testName: testName) {
                        cells.append(testCell)
                    }
                }
            }
            
            // Recommendations
            if let recommendations = device.measurements?.recommendations {
                cells.append(.notificationsHeader)
                for _ in recommendations {
                    cells.append(.notification)
                }
            }
        }
        
        self.cells = cells
        return cells
    }
    
    func getNotificationIndex(_ currentIndex: Int) -> Int {
        return currentIndex - (self.cells.firstIndex(of: .notification) ?? 0)
    }
    
    func getNotificationIndexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let firstNotificationIndex = self.cells.firstIndex(of: .notification) ?? 0
        for row in firstNotificationIndex..<self.cells.count {
            let indexPath = IndexPath(row: row, section: 0)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
    private func addCompleteProfileRecommendationIfNeeded() {
        if self.userProfileIncomplete() {
            var userProfileRecommendation = TestRecommendation()
            userProfileRecommendation.text = "User Profile Action Needed"
            userProfileRecommendation.severity = .high
            userProfileRecommendation.type = .userProfileIncomplete
            self.devices?[safe: 0]?.measurements?.recommendations?.insert(userProfileRecommendation, at: 0)
        }
    }
    
    private func userProfileIncomplete() -> Bool {
        return self.firstName == nil || self.firstName?.isEmpty ?? true ||
                self.lastName == nil || self.lastName?.isEmpty ?? true ||
                self.phone == nil || self.phone?.isEmpty ?? true ||
                self.address == nil || self.address?.hasMissingFields() ?? true
    }
    
    // MARK: - Static helpers
    
    static func noDeviceViewModel() -> HomeViewModel {
        let testViewModel = HomeViewModel()
        if let device = Device.getNoDeviceData() {
            testViewModel.devices = [device]
        }
        return testViewModel
    }
    
    static func getTestViewModel() -> HomeViewModel {
        let testViewModel = HomeViewModel()
        if let device = Device.getTestDevice() {
            testViewModel.devices = [device]
        }
        return testViewModel
    }
}

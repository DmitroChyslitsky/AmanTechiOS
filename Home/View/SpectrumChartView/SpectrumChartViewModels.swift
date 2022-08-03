//
//  SpectrumChartViewModels.swift
//  Amano
//
//  Created by Alex Murray on 2/15/22.
//

import UIKit

struct SpectrumChartBucket {
    var min = 0.0
    var max = 0.0
    var color = UIColor.white
    var shouldDisplayMin = false
    var midNumber: Double?
}

class SpectrumChartViewModel {
    var testName: TestName?
    var locationType: LocationType = .pool
    var selectedNumber: Double?
    var middleNumber: Double?
    
    var buckets = [SpectrumChartBucket]()
    
    init(testName: TestName, locationType: LocationType, selectedNumber: Double) {
        self.testName = testName
        self.locationType = locationType
        self.selectedNumber = selectedNumber
        
        switch testName {
        case .pH:
            self.configureForPH()
        case .alkalinity:
            self.configureForAlkalinity()
        case .freeChlorine:
            self.configureForFreeChlorine()
        case .combinedChlorine:
            self.configureForCombinedChlorine()
        case .bromine:
            self.configureForBromine()
        default:
            return
        }
    }
    
    private func configureForPH() {
        self.middleNumber = 7.5
        switch self.locationType {
        case .pool, .combo:
            self.buckets = [SpectrumChartBucket(min: 7.1, max: 7.2, color: .failure),
                            SpectrumChartBucket(min: 7.2, max: 7.4, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 7.4, max: 7.6, color: .success, midNumber: 7.5),
                            SpectrumChartBucket(min: 7.6, max: 7.8, color: .primaryAccent),
                            SpectrumChartBucket(min: 7.8, max: 7.9, color: .failure, shouldDisplayMin: true)]
        case .spa:
            self.buckets = [SpectrumChartBucket(min: 7.1, max: 7.2, color: .failure),
                            SpectrumChartBucket(min: 7.2, max: 7.4, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 7.4, max: 7.6, color: .success, midNumber: 7.5),
                            SpectrumChartBucket(min: 7.6, max: 7.8, color: .primaryAccent),
                            SpectrumChartBucket(min: 7.8, max: 7.9, color: .failure, shouldDisplayMin: true)]
        }
    }
    
    private func configureForAlkalinity() {
        self.middleNumber = 110
        switch self.locationType {
        case .pool, .combo:
            self.buckets = [SpectrumChartBucket(min: 40, max: 60, color: .failure),
                            SpectrumChartBucket(min: 60, max: 100, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 100, max: 120, color: .success, midNumber: 110),
                            SpectrumChartBucket(min: 120, max: 180, color: .primaryAccent),
                            SpectrumChartBucket(min: 180, max: 200, color: .failure, shouldDisplayMin: true)]
        case .spa:
            self.buckets = [SpectrumChartBucket(min: 40, max: 60, color: .failure),
                            SpectrumChartBucket(min: 60, max: 100, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 100, max: 120, color: .success, midNumber: 110),
                            SpectrumChartBucket(min: 120, max: 180, color: .primaryAccent),
                            SpectrumChartBucket(min: 180, max: 200, color: .failure, shouldDisplayMin: true)]
        }
    }
    
    private func configureForFreeChlorine() {
        switch self.locationType {
        case .pool, .combo:
            self.middleNumber = 3
            self.buckets = [SpectrumChartBucket(min: 0, max: 1, color: .failure),
                            SpectrumChartBucket(min: 1, max: 2, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 2, max: 4, color: .success, midNumber: 3),
                            SpectrumChartBucket(min: 4, max: 5, color: .primaryAccent),
                            SpectrumChartBucket(min: 5, max: 6, color: .failure, shouldDisplayMin: true)]
        case .spa:
            self.middleNumber = 4
            self.buckets = [SpectrumChartBucket(min: 0, max: 2, color: .failure),
                            SpectrumChartBucket(min: 2, max: 3, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 3, max: 5, color: .success, midNumber: 4),
                            SpectrumChartBucket(min: 5, max: 10, color: .primaryAccent),
                            SpectrumChartBucket(min: 10, max: 12, color: .failure, shouldDisplayMin: true)]
        }
    }
    
    private func configureForCombinedChlorine() {
        switch self.locationType {
        case .pool, .combo:
            self.buckets = [SpectrumChartBucket(min: 0, max: 0.05, color: .success),
                            SpectrumChartBucket(min: 0.05, max: 0.2, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 0.2, max: 0.25, color: .failure, shouldDisplayMin: true)]
        case .spa:
            self.buckets = [SpectrumChartBucket(min: 0, max: 0.1, color: .success),
                            SpectrumChartBucket(min: 0.1, max: 0.5, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 0.5, max: 0.6, color: .failure, shouldDisplayMin: true)]
        }
    }
    
    private func configureForBromine() {
        self.middleNumber = 5
        switch self.locationType {
        case .pool, .combo:
            self.buckets = [SpectrumChartBucket(min: 0, max: 2, color: .failure),
                            SpectrumChartBucket(min: 2, max: 4, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 4, max: 6, color: .success, midNumber: 5),
                            SpectrumChartBucket(min: 6, max: 10, color: .primaryAccent),
                            SpectrumChartBucket(min: 10, max: 12, color: .failure, shouldDisplayMin: true)]
        case .spa:
            self.buckets = [SpectrumChartBucket(min: 0, max: 2, color: .failure),
                            SpectrumChartBucket(min: 2, max: 4, color: .primaryAccent, shouldDisplayMin: true),
                            SpectrumChartBucket(min: 4, max: 6, color: .success, midNumber: 5),
                            SpectrumChartBucket(min: 6, max: 10, color: .primaryAccent),
                            SpectrumChartBucket(min: 10, max: 12, color: .failure, shouldDisplayMin: true)]
        }

    }
    
    // MARK: - Public Helpers
    
    func getChartMin() -> Double {
        return self.buckets.first?.min ?? 0.0
    }
    
    func getChartMax() -> Double {
        return self.buckets.last?.max ?? 0.0
    }
}

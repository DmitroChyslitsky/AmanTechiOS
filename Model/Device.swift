//
//  Device.swift
//  Amano
//
//  Created by Alex Murray on 2/10/22.
//

import Foundation
import ESPProvision

struct Device: Codable {
    
    static let totalTestCount = 31
    
    // Looks like some endpoints return deviceId while others returrn uuid
    var deviceId: String?
    var uuid: String?
    
    var name: String?
    
    var properties: DeviceProperties?
    var location: DeviceLocation?
    var status: DeviceStatus?
    var measurements: DeviceMeasurements?
    
    // Convenience init used when updating device location
    init(id: String, name: String, location: DeviceLocation) {
        self.deviceId = id
        self.name = name
        self.location = location
    }
}

struct DeviceProperties: Codable {
    var installMethod: String?
    var testFrequency: Double?
    var testTimePreference: String?
    var cartridgeId: String?
    var firmwareVersion: String?
}

enum LocationType: String, Codable, CaseIterable {
    case pool
    case spa
    case combo
    
    public init(from decoder: Decoder) throws {
        self = try LocationType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .pool
    }
    
    var title: String {
        get {
            switch self {
            case .pool:
                return "Pool"
            case .spa:
                return "Spa"
            case .combo:
                return "Pool & spa combo"
            }
        }
    }
    
    var name: String {
        get {
            switch self {
            case .pool:
                return "Pool"
            case .spa:
                return "Spa"
            case .combo:
                return "Combo"
            }
        }
    }
}

enum SurfaceType: String, CaseIterable {
    case vinyl
    case concrete
    case fiberglass
    case other
    
    var title: String {
        get {
            switch self {
            case .vinyl:
                return "Vinyl"
            case .concrete:
                return "Concrete"
            case .fiberglass:
                return "Fiberglass"
            case .other:
                return "I don't know/Other"
            }
        }
    }
}

enum SanitizerType: String, CaseIterable {
    case chlorine
    case bromine
    case salt
    case mineral
    case other
    
    var title: String {
        get {
            switch self {
            case .chlorine:
                return "Chlorine"
            case .bromine:
                return "Bromine"
            case .salt:
                return "Salt"
            case .mineral:
                return "Mineral"
            case .other:
                return "I don't know/Other"
            }
        }
    }
}

enum PumpType: String, CaseIterable {
    case single
    case dual
    case variable
    case other
    
    var title: String {
        get {
            switch self {
            case .single:
                return "Single speed"
            case .dual:
                return "Dual speed"
            case .variable:
                return "Variable speed"
            case .other:
                return "I don't know/Other"
            }
        }
    }
}

struct DeviceLocation: Codable {
    var construction: String?
    var installation: String?
    var pump: String?
    var sanitizer: String?
    var size: Int?
    var type: LocationType?
    var address: Address?
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(construction, forKey: CodingKeys.construction)
        try container.encodeIfPresent(installation, forKey: CodingKeys.installation)
        try container.encodeIfPresent(pump, forKey: CodingKeys.pump)
        try container.encodeIfPresent(sanitizer, forKey: CodingKeys.sanitizer)
        try container.encodeIfPresent(size, forKey: CodingKeys.size)
        try container.encodeIfPresent(type, forKey: CodingKeys.type)
        try container.encodeIfPresent(address, forKey: CodingKeys.address)
    }
}

struct DeviceStatus: Codable {
    var timestamp: String? // "yyyy-mm-dd hh:mm:ss"
    var currentStatus: String?
    var battery: Int?
    var testsRemaining: Int?
    var waterTempF: Float?
}

struct DeviceMeasurements: Codable {
    var timestamp: String? // "yyyy-mm-dd hh:mm:ss"
    var tests: [DeviceTest]?
    var recommendations: [TestRecommendation]?
}

enum TestName: String, Codable {
    case pH
    case alkalinity = "Alkalinity"
    case freeChlorine = "Free Chlorine"
    case combinedChlorine = "Combined Chlorine"
    case bromine = "Bromine"
    case other
    
    public init(from decoder: Decoder) throws {
        self = try TestName(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .other
    }
}

struct DeviceTest: Codable {
    var testName: TestName?
    var value: Double?
}

enum RecommendationSeverity: Int, Codable {
    case high = 1
    case medium = 2
}

enum RecommendationType: String, Codable {
    case noDevice
    case userProfileIncomplete
}

struct TestRecommendation: Codable, Equatable, Hashable {
    var text: String?
    var details: String?
    var severity: RecommendationSeverity?
    var type: RecommendationType?
}

extension ESPDevice {
    // Hide Prefix from user
    var idOnly: String {
        return self.name.replacingOccurrences(of: ProvisioningManager.prefix, with: "")
    }
}

// MARK : - Hardcoded values for when the user does not have a device or for local testing

extension Device {
    static func getNoDeviceData() -> Device? {
        let jsonString = "{\"measurements\":{\"tests\":[{\"testName\":\"pH\",\"value\":0.0},{\"value\":0.0,\"testName\":\"Free Chlorine\"},{\"value\":0.0,\"testName\":\"Combined Chlorine\"},{\"testName\":\"Alkalinity\",\"value\":0}],\"timestamp\":\"\",\"recommendations\":[{\"text\":\"No Device Connected\",\"severity\":1, \"type\": \"noDevice\"}]},\"status\":{\"testsRemaining\":0,\"battery\":0, \"waterTempF\": 0},\"name\":\"\"}"
        guard let data = jsonString.data(using: .utf8, allowLossyConversion: false) else { return nil }
        do {
            let decoder = JSONDecoder()
            let device = try decoder.decode(Device.self, from: data)
            return device
        } catch let error as DecodingError {
               switch error {
                case .typeMismatch(let key, let value):
                  print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                case .valueNotFound(let key, let value):
                  print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                case .keyNotFound(let key, let value):
                  print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                case .dataCorrupted(let key):
                  print("error \(key), and ERROR: \(error.localizedDescription)")
                default:
                  print("ERROR: \(error.localizedDescription)")
                }
            return nil
        } catch {
            return nil
        }
    }
    
    static func getTestDevice() -> Device? {
        let jsonString = "{\"newCartridge\":false,\"location\":{\"installation\":\"\",\"zipCode\":\"\",\"type\":\"\",\"pump\":\"\",\"construction\":\"\",\"sanitizer\":\"chlorine\"},\"properties\":{\"firmwareVersion\":\"1.0.0\",\"installMethod\":\"\",\"testTimePreference\":\"10:00:00\",\"testFrequency\":1},\"reagentUsed\":{},\"measurements\":{\"timestamp\":\"2022-04-18 21:15:25\",\"reagentUsed\":{\"reagent6\":22,\"reagent2\":10,\"reagent3\":32,\"reagent4\":30,\"reagent5\":10,\"reagent1\":52},\"tests\":[{\"value\":12.04899,\"status\":0,\"testName\":\"pH\"},{\"value\":259.720249,\"testName\":\"Alkalinity\",\"status\":-7},{\"testName\":\"Free Chlorine\",\"status\":0,\"value\":1.597726},{\"status\":0,\"testName\":\"Combined Chlorine\",\"value\":\"5.6943\"}],\"recommendations\":[{\"details\":\"Combined chlorine levels are very high. Add 5 3/4 cups of liquid chlorine as a shock to decrease combined chlorine levels\",\"code\":302,\"text\":\"Add 5 3/4 cups of liquid chlorine\",\"severity\":2,\"flOz\":45.89968057066667}]},\"status\":{\"waterTempC\":21.43,\"cartridgeIn\":true,\"inPool\":true,\"inlinePumpOn\":false,\"internalTemp\":3157,\"lidOpen\":false,\"internalTempF\":88.83,\"testsRemaining\":13,\"internalTempC\":31.57,\"waterTempF\":70.57,\"waterTemp\":2143,\"timestamp\":\"2022-04-18 21:18:15\",\"battery\":78},\"cartridgeId\":\"0001\",\"limits\":{\"Alkalinity\":[40,60,100,110,120,180,200],\"pH\":[7.1,7.2,7.4,7.5,7.6,7.8,7.9]},\"deviceId\":\"9Wn9dTeIkuQHPR0BI6vd\",\"name\":\"No name\"}"
        guard let data = jsonString.data(using: .utf8, allowLossyConversion: false) else { return nil }
        do {
            let decoder = JSONDecoder()
            let device = try decoder.decode(Device.self, from: data)
            return device
        } catch let error as DecodingError {
               switch error {
                case .typeMismatch(let key, let value):
                  print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                case .valueNotFound(let key, let value):
                  print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                case .keyNotFound(let key, let value):
                  print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
                case .dataCorrupted(let key):
                  print("error \(key), and ERROR: \(error.localizedDescription)")
                default:
                  print("ERROR: \(error.localizedDescription)")
                }
            return nil
        } catch {
            return nil
        }
    }
}

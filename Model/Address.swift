//
//  Address.swift
//  Amano
//
//  Created by Alex Murray on 3/23/22.
//

import Foundation

class Address: Codable {
    var street1: String?
    var street2: String?
    var city: String?
    var state: String?
    var zipCode: String?
    
    func hasMissingFields() -> Bool {
        // street2 is optional
        return self.street1 == nil || self.street1?.isEmpty ?? false ||
            self.city == nil || self.city?.isEmpty ?? false ||
            self.state == nil || self.state?.isEmpty ?? false ||
            self.zipCode == nil || self.zipCode?.isEmpty ?? false
    }
}

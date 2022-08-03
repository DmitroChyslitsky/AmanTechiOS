//
//  Network.swift
//  Amano
//
//  Created by Alex Murray on 2/7/22.
//

import Alamofire
import Foundation

class Network {
    
    static let bearer = "Bearer "
    static let authorization = "Authorization"
    static let applicationJSON = "application/json"
    static let contentType = "Content-Type"
    
    // MARK - Headers
    
    class func getHeaders(completion: @escaping(_ httpHeaders: HTTPHeaders?) -> Void) {
        AuthenticationManager.shared.currentAuthToken { token in
            if let token = token {
                let headersDictionary = [Network.authorization: Network.bearer + token,
                                         Network.contentType: Network.applicationJSON]
                let headers = HTTPHeaders(headersDictionary)
                completion(headers)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - User
    
    class func updateProfile(user: User, completion: @escaping(_ success: Bool) -> Void) {
        guard let url = URL(string: API.root + APIPath.updateProfile) else {
            completion(false)
            return
        }
        
        Network.getHeaders { headers in
            AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.prettyPrinted, headers: headers).validate(statusCode: 200..<300).responseData { response in
                switch response.result {
                case .success:
                    NotificationCenter.default.post(name: NotificationName.homeRefreshNeeded, object: nil)
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
    }
    
    class func getUserProfile(completion: @escaping(_ user: User?) -> Void) {
        guard let url = URL(string: API.root + APIPath.profile) else {
            completion(nil)
            return
        }
        
        Network.getHeaders { headers in
            AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: User.self) { response in
                switch response.result {
                case .success:
                    if let user = response.value {
                        completion(user)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Device
    
    class func assignDevice(deviceId: String, completion: @escaping(_ deviceId: String?) -> Void) {
        guard let url = URL(string: API.root + APIPath.assignDevice + deviceId) else {
            completion(nil)
            return
        }
        
        Network.getHeaders { headers in
            AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: Device.self) { response in
                switch response.result {
                case .success:
                    if let deviceId = response.value?.deviceId {
                        NotificationCenter.default.post(name: NotificationName.homeRefreshNeeded, object: nil)
                        completion(deviceId)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    class func updateDeviceLocation(deviceId: String, name: String, deviceLocation: DeviceLocation, completion: @escaping(_ success: Bool) -> Void) {
        guard let url = URL(string: API.root + APIPath.updateDecice) else {
            completion(false)
            return
        }
        
        let device = Device(id: deviceId, name: name, location: deviceLocation)
        
        Network.getHeaders { headers in
            AF.request(url, method: .post, parameters: device, encoder: JSONParameterEncoder.prettyPrinted, headers: headers).validate(statusCode: 200..<300).responseData { response in
                switch response.result {
                case .success:
                    NotificationCenter.default.post(name: NotificationName.homeRefreshNeeded, object: nil)
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Home
    
    class func home(completion: @escaping(_ viewModel: HomeViewModel?) -> Void) {
        guard let url = URL(string: API.root + APIPath.home) else {
            completion(nil)
            return
        }
        
        Network.getHeaders { headers in
            AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: HomeViewModel.self) { response in
                switch response.result {
                case .success:
                    if let viewModel = response.value {
                        completion(viewModel)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}

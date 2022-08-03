//
//  AccountViewController.swift
//  Amano
//
//  Created by Alex Murray on 2/7/22.
//

import UIKit

class AccountViewController: UIViewController {
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleAutoOpen()
    }
    
    private func handleAutoOpen() {
        if SessionManager.shared.autoOpenType == .editProfile {
            SessionManager.shared.autoOpenType = nil
            self.showUserProfileInfoViewController()
        }
    }
    
    // MARK: - Actions (These are temporary until UI exists, may need to be removed in the future)
    
    @IBAction func logoutAction(_ sender: Any) {
        AuthenticationManager.shared.signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        self.showUserProfileInfoViewController()
    }
    
    @IBAction func updateDeviceLocationAction(_ sender: Any) {
        // Fetch latest device info
        Network.home(completion: { viewModel in
            if let viewModel = viewModel, let deviceId = viewModel.devices?.first?.deviceId {
                let storyboard: UIStoryboard = UIStoryboard(name: "Provisioning", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "DeviceLocationInfoViewController") as? DeviceLocationInfoViewController {
                    vc.deviceId = deviceId
                    self.show(vc, sender: self)
                }
            } else {
                Utility.showGenericError(text: "No valid device found") // Change message when backend data issues are resolved
            }
        })
    }
    
    // MARK: - Helpers
    
    private func showUserProfileInfoViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SignUpInfoViewController") as? SignUpInfoViewController {
            vc.user = AuthenticationManager.shared.getCurrentUser()
            vc.isUpdate = true
            self.show(vc, sender: self)
        }
    }
  
    
    @IBAction private func handleInstallSelection(_ sender: Any) {
      let vc = InstallSelectionViewController()
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .overFullScreen

      present(nav, animated: true)
    }
}

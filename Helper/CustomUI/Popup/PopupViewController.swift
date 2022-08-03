//
//  PopupViewController.swift
//  Amano
//
//  Created by Alex Murray on 3/28/22.
//

import UIKit

enum PopupType {
    case resetPassword
    case misc
}

protocol PopupViewControllerDelegate {
    func leftButtonAction(type: PopupType, text: String?)
    func rightButtonAction(type: PopupType)
}

class PopupViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textField: FloatingLabelTextField!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: PopupViewControllerDelegate?
    private var type = PopupType.misc
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.overlayView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.overlayView.isHidden = true
        super.viewWillDisappear(animated)
    }
    
    private func configureUI() {
        switch self.type {
        case .resetPassword:
            self.configureForResetPassword()
        case .misc:
            return
        }
    }
    
    private func configureForResetPassword() {
        self.titleLabel.text = "Reset Password"
        self.messageLabel.text = "Enter your email address below and we will send you a link to reset your password"
        self.leftButton.setTitle("Send", for: .normal)
        self.rightButton.setTitle("Cancel", for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func leftButtonAction(_ sender: Any) {
        self.close()
        delegate?.leftButtonAction(type: self.type, text: self.textField.text)
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        self.close()
        delegate?.rightButtonAction(type: self.type)
    }
    
}

// MARK: - Static Functions

extension PopupViewController {
    static func showPopup(type: PopupType, presentingViewController: UIViewController, delegate: PopupViewControllerDelegate? = nil) {
        if let controller = UIStoryboard(name: "PopupViewController", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as? PopupViewController {
            controller.delegate = delegate
            controller.type = type
            controller.modalPresentationStyle = .overCurrentContext
            
            presentingViewController.present(controller, animated: true, completion: nil)
        }
    }
}

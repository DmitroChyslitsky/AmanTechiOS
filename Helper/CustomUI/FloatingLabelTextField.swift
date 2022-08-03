//
//  FloatingLabelTextField.swift
//
//
//  Created by Alex Murray on 5/17/21.
//  Copyright © 2021 Axle Development LLC. All rights reserved.
//

import UIKit

protocol FloatingLabelTextFieldDelegate {
    func rightViewAction(textField: FloatingLabelTextField)
}

class FloatingLabelTextField: UITextField {
    
    var floatingLabelTextFieldDelegate: FloatingLabelTextFieldDelegate?

    // Padding
    static let topSpace: CGFloat = 8.0
    static let leftSpace: CGFloat = 10.0
    static let filledTopSpace: CGFloat = 12.0
    
    private let emptyTextPadding = UIEdgeInsets(top: 0, left: FloatingLabelTextField.leftSpace, bottom: 0, right: -FloatingLabelTextField.leftSpace)
    private let filledTextPadding = UIEdgeInsets(top: FloatingLabelTextField.filledTopSpace, left: FloatingLabelTextField.leftSpace, bottom: -FloatingLabelTextField.topSpace, right: -FloatingLabelTextField.leftSpace)

    // Floating Label
    var floatingLabel: UILabel = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 10
    var floatingLabelFont: UIFont = UIFont(name: "Roboto-Medium", size: 14.0)! {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }

    // IBInspecables
    @IBInspectable var canPerformAction: Bool = true
    @IBInspectable var floatingPlaceholder: String?
    @IBInspectable var floatingLabelColor: UIColor = UIColor.label {
        didSet {
            self.floatingLabel.textColor = self.floatingLabelColor
            self.setNeedsDisplay()
        }
    }

    @IBInspectable var activeBorderColor: UIColor = UIColor.label
    @IBInspectable var activeBorderWdith: CGFloat = 1.0
    @IBInspectable var activeBackgroundColor: UIColor = UIColor.clear

    // Store default values (see setInactiveValues and deactivateTextField)
    private var inactiveBorderColor: CGColor?
    private var inactiveBorderWidth: CGFloat?
    private var inactiveBackgroundColor: UIColor?

    override var text: String? {
        didSet {
            if let text = self.text, !text.isEmpty {
                self.addFloatingLabel()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.floatingPlaceholder = (self.floatingPlaceholder != nil) ? self.floatingPlaceholder : placeholder // Use our custom placeholder if none is set
        self.placeholder = self.floatingPlaceholder // make sure the placeholder is shown

        self.floatingLabel = UILabel(frame: CGRect.zero)

        self.addTarget(self, action: #selector(self.activateTextField), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.deactivateTextField), for: .editingDidEnd)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setInactiveValues()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.filledTextPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.emptyTextPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.filledTextPadding)
    }

    private func setInactiveValues() {
        if let borderColor = self.layer.borderColor {
            self.inactiveBorderColor = borderColor
        }
        self.inactiveBorderWidth = self.borderWidth
        self.inactiveBackgroundColor = backgroundColor
    }

    @objc func activateTextField() {
        self.layer.borderColor = self.activeBorderColor.cgColor
        self.layer.borderWidth = self.activeBorderWdith
        // self.backgroundColor = self.activeBackgroundColor
        self.addFloatingLabel()
    }

    @objc func addFloatingLabel() {
        self.floatingLabel.textColor = self.floatingLabelColor
        self.floatingLabel.font = self.floatingLabelFont
        self.floatingLabel.text = self.floatingPlaceholder
        self.floatingLabel.backgroundColor = self.activeBackgroundColor
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.floatingLabelHeight)
        self.addSubview(self.floatingLabel)

        //Constraints
        self.floatingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: FloatingLabelTextField.topSpace).isActive = true
        self.floatingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: FloatingLabelTextField.leftSpace).isActive = true

        self.placeholder = "" // Remove the placeholder since its in the floating label

        self.setNeedsDisplay()
    }

    @objc func deactivateTextField() {
        DispatchQueue.main.async {
            if self.text == "" {
                UIView.animate(withDuration: 0.13) {
                    self.floatingLabel.removeFromSuperview()
                }
                self.placeholder = self.floatingPlaceholder
            }

            self.layer.borderColor = self.inactiveBorderColor
            self.layer.borderWidth = self.inactiveBorderWidth ?? 0.0
        }
    }
    
    // MARK: - Right View
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 30, y: 0, width: 20 , height: bounds.height)
    }
    
    func setRightViewForDropDown() {
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 22))
        rightImageView.isUserInteractionEnabled = true
        rightImageView.contentMode = .center
        rightImageView.image = UIImage(systemName: "chevron.down")
        rightImageView.tintColor = .label
        
        // Tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightViewAction))
        rightImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.rightView = rightImageView
        self.rightViewMode = .always
        self.inputView = UIView()
        self.inputAccessoryView = UIView()
    }
    
    @objc private func rightViewAction() {
        self.floatingLabelTextFieldDelegate?.rightViewAction(textField: self)
    }
}


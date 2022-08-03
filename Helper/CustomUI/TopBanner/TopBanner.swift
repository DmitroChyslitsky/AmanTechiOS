//
//  TopBanner.swift
//  Amano
//
//  Created by Alex Murray on 2/26/22.
//

import UIKit

enum TopBannerType {
    case success
    case failure
}

class TopBanner: CustomView {
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    static let defaultHeight: CGFloat = 80.0
    static let animationDuration = 0.2
    static let bannerDuration = 5.0
    static let iconConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
    
    // MARK: - View
    
    override func nibName() -> String {
        return "TopBanner"
    }
    
    func configure(type: TopBannerType, title: String? = nil, message: String? = nil) {
        DispatchQueue.main.async {
            // Text
            self.titleLabel.text = title
            self.messageLabel.text = message
            self.messageLabel.isHidden = message == nil ? true : false
            
            // Styling
            switch type {
            case .success:
                self.bannerView.backgroundColor = .success
                self.imageView.image = UIImage(systemName: "checkmark", withConfiguration: TopBanner.iconConfig)
            case .failure:
                self.bannerView.backgroundColor = .failure
                self.imageView.image = UIImage(systemName: "xmark", withConfiguration: TopBanner.iconConfig)
            }
            
            // Configure For No Image
            if self.imageView.image == nil {
                self.imageView.isHidden = true
                self.titleLabel.textAlignment = .center
                self.messageLabel.textAlignment = .center
            }
            
            // Swipe to dismiss
            let swipeAway = UISwipeGestureRecognizer(target: self, action: #selector(self.hide))
            swipeAway.direction = .up
            self.addGestureRecognizer(swipeAway)
            
            self.frame = CGRect(x: 0, y: -TopBanner.defaultHeight, width: UIScreen.main.bounds.width, height: TopBanner.defaultHeight)
        }
    }
    
    func show(isPersistent: Bool = false) {
        DispatchQueue.main.async {
            if let parentView = Utility.getKeyWindow() {
                parentView.addSubview(self)
                
                UIView.animate(withDuration: TopBanner.animationDuration, animations: {
                    self.frame = CGRect(x: 0, y: parentView.safeAreaInsets.top, width: self.frame.width, height: self.frame.height)
                    parentView.layoutIfNeeded()
                })
                
                if !isPersistent {
                    self.perform(#selector(self.hide), with: nil, afterDelay: TopBanner.bannerDuration)
                }
            }
        }
    }
    
    @objc func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: TopBanner.animationDuration / 2, animations: {
                self.frame = CGRect(x: 0, y: -TopBanner.defaultHeight, width: self.frame.width, height: self.frame.height)
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}

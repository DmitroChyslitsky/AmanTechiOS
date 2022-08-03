//
//  HomeTableViewCells.swift
//  Amano
//
//  Created by Alex Murray on 2/15/22.
//

import UIKit

class HomeHeaderCell: UITableViewCell {
    
}

class HomeSubheaderCell: UITableViewCell {
    
    @IBOutlet weak var batteryProgressView: UIProgressView!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var testsRemainingProgressView: UIProgressView!
    @IBOutlet weak var testsRemainingLabel: UILabel!
    @IBOutlet weak var temperatureReadingLabel: UILabel!
    
}

class HomeTestCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var ppmLabel: UILabel!
    @IBOutlet weak var spectrumChartView: SpectrumChartView!
    
    var spectrumChartViewModel: SpectrumChartViewModel? {
        didSet {
            self.spectrumChartView?.viewModel = spectrumChartViewModel
            self.configureUI()
        }
    }
    
    override func prepareForReuse() {
        self.ppmLabel.alpha = 1
    }
    
    private func configureUI() {
        guard let spectrumChartViewModel = spectrumChartViewModel else { return }

        DispatchQueue.main.async {
            self.titleLabel.text = spectrumChartViewModel.testName?.rawValue
            self.readingLabel.text = spectrumChartViewModel.selectedNumber?.cleanString()
            if spectrumChartViewModel.testName == .pH {
                self.ppmLabel.alpha = 0 // Keeps uniform stack view spacing by not using isHidden
            }
        }
    }
}

class HomeLastTestCell: UITableViewCell {
    
    @IBOutlet weak var lastTestLabel: UILabel!
}

class HomeNotificationsHeaderCell: UITableViewCell {
    
}

class HomeNotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificationContentView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var detailsContainerView: UIStackView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    func setRecommendation(_ recommendation: TestRecommendation, hideDetails: Bool = true) {
        self.notificationLabel.text = recommendation.text
        self.notificationContentView.layer.masksToBounds = false
        
        self.detailsContainerView.isHidden = hideDetails
        self.detailsLabel.isHidden = hideDetails
        if !hideDetails {
            self.rightImageView.image = UIImage(systemName: "chevron.up")
        } else {
            self.rightImageView.image = UIImage(systemName: "chevron.down")
        }
        
        if let details = recommendation.details {
            self.rightImageView.isHidden = false
            self.detailsLabel.text = details
        } else {
            self.rightImageView.isHidden = true
        }
        
        if let severity = recommendation.severity {
            switch severity {
            case .high:
                self.notificationContentView.borderColor = UIColor.alertAccent
                self.notificationLabel.textColor = UIColor.alertAccent
                self.detailsLabel.textColor = UIColor.alertAccent
                self.statusView.backgroundColor = UIColor.alertAccent
                self.rightImageView.tintColor = UIColor.alertAccent
            case .medium:
                self.notificationContentView.borderColor = UIColor.secondaryAlertAccent
                self.notificationLabel.textColor = UIColor.secondaryAlertAccent
                self.detailsLabel.textColor = UIColor.secondaryAlertAccent
                self.statusView.backgroundColor = UIColor.secondaryAlertAccent
                self.rightImageView.tintColor = UIColor.secondaryAlertAccent
            }
        }
    }
}

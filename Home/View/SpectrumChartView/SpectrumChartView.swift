//
//  SpectrumChartView.swift
//  Amano
//
//  Created by Alex Murray on 2/15/22.
//

import UIKit


class SpectrumChartView: CustomView {
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var spectrumStackView: UIStackView!
    
    var viewModel: SpectrumChartViewModel? {
        didSet {
            self.configureForViewModel()
        }
    }
    
    // MARK: - View
    
    override func nibName() -> String {
        return "SpectrumChartView"
    }
    
    private func configureForViewModel() {
        guard let viewModel = viewModel else { return }
        
        DispatchQueue.main.async {
            
            // Chart setup
            self.layoutSubviews()
            let chartMin = viewModel.getChartMin()
            let chartMax = viewModel.getChartMax()
            let chartRange = chartMax - chartMin
            let chartWidth = self.spectrumStackView.frame.width
            let multiplier = chartWidth / chartRange
        
            // Bucket setup
            self.clearSpectrumView()
            for bucket in viewModel.buckets {
                let bucketRange = bucket.max - bucket.min
                let bucketWidth: CGFloat = bucketRange * multiplier
                let bucketView = UIView()
                bucketView.backgroundColor = bucket.color
                
                let widthConstraint = NSLayoutConstraint(item: bucketView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: bucketWidth)
                bucketView.addConstraint(widthConstraint)
                self.spectrumStackView.addArrangedSubview(bucketView)
                
                // Labels
                if let midNumber = bucket.midNumber {
                    self.addLabel(x: (midNumber - chartMin) * multiplier, number: midNumber)
                }
                if bucket.shouldDisplayMin {
                    self.addLabel(x: (bucket.min - chartMin) * multiplier, number: bucket.min)
                }
            }
            
            // Selected number setup
            if let selectedNumber = viewModel.selectedNumber {
                if selectedNumber <= viewModel.getChartMin() {
                    // Display min
                    self.indicatorCenterConstraint.constant = 0.0
                    if let firstBucket = viewModel.buckets.first {
                        self.indicatorView.backgroundColor = firstBucket.color
                    }
                } else if selectedNumber >= viewModel.getChartMax() {
                    // Display max
                    self.indicatorCenterConstraint.constant = self.spectrumStackView.frame.width
                    if let lastBucket = viewModel.buckets.last {
                        self.indicatorView.backgroundColor = lastBucket.color
                    }
                } else if let bucket = self.bucketFor(number: selectedNumber){
                    // Display in matching bucket
                    self.indicatorCenterConstraint.constant = (selectedNumber - chartMin) * multiplier
                    self.indicatorView.backgroundColor = bucket.color
                }
                self.layoutSubviews()
            }
        }
    }
    
    private func addLabel(x: CGFloat, number: Double) {
        DispatchQueue.main.async {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
            label.center = CGPoint(x: x, y: self.spectrumStackView.frame.origin.y + self.spectrumStackView.frame.height + 16.0)
            label.font = UIFont(name: "Roboto-Medium", size: 12.0)
            label.textColor = .white
            label.text = number.cleanString()
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    private func bucketFor(number: Double) -> SpectrumChartBucket? {
        guard let viewModel = viewModel else { return nil }
        for bucket in viewModel.buckets {
            if number >= bucket.min && number <= bucket.max {
                return bucket
            }
        }
        
        return nil
    }
    
    private func clearSpectrumView() {
        // Remove buckets
        for view in self.spectrumStackView.subviews {
            self.spectrumStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Clear added labels
        for label in self.subviews where ((label as? UILabel) != nil) {
            label.removeFromSuperview()
        }
    }
}

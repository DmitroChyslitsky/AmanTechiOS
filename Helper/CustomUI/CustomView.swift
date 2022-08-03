//
//  CustomView.swift
//  Amano
//
//  Created by Alex Murray on 2/5/22.
//

import UIKit

class CustomView: UIView {
    
    /// IMPORTANT: Every subclase of CustomView MUST override this function with its nibName. The class should also be set as the FILE'S OWNER in the nib
    func nibName() -> String {
        return ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        let view = self.loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName(), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

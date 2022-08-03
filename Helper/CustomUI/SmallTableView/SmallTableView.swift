//
//  SmallTableView.swift
//  Amano
//
//  Created by Alex Murray on 2/8/22.
//

import UIKit

class SmallTableView: CustomView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View
    
    override func nibName() -> String {
        return "SmallTableView"
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
//    }
}

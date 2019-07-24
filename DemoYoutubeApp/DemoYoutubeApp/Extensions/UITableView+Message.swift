//
//  UITableView+Message.swift
//  DemoYoutubeApp
//
//  Created by Diana Ivascu on 7/24/19.
//  Copyright © 2019 Diana Melita. All rights reserved.
//

import UIKit

extension UITableView {
    
    func displayMessage(_ message: String) {
        
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                         width: self.bounds.size.width,
                                                         height: self.bounds.size.height))
        noDataLabel.numberOfLines = 0
        noDataLabel.text = message
        noDataLabel.textColor = .black
        noDataLabel.textAlignment = NSTextAlignment.center
        self.backgroundView = noDataLabel
    }
    
    func hideMessageLabel() {
        
        self.backgroundView?.isHidden = true
    }
}

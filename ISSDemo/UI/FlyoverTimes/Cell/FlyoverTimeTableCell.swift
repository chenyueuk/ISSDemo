//
//  FlyoverTimeTableCell.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit

class FlyoverTimeTableCell: BorderedTableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    
    // MARK: - Methods
    
    /// Update cell date time labels with given date
    ///
    /// - Parameters:
    ///   - date: Date value for the labels
    func setDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd MMM yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        dateLabel?.text = dateFormatter.string(from: date)
        timeLabel?.text = timeFormatter.string(from: date)
    }
}

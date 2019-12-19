//
//  BorderedTableViewCell.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit

class BorderedTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Add padding
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        /// Add border
        contentView.layer.borderColor = textLabel?.textColor.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 8.0
    }

}

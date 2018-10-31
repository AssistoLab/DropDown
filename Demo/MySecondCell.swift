//
//  MySecondCell.swift
//  Demo
//
//  Created by Aleksei Cherepanov on 31/10/2018.
//  Copyright © 2018 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

class MySecondCell: DropDownCustomCell {
    var logoImageView = UIImageView(frame: .zero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(logoImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.frame = CGRect(origin: .zero,
                                     size: CGSize(width: frame.height, height: frame.height))
        optionLabel.frame = CGRect(x: frame.height, y: 0, width: frame.width - frame.height, height: frame.height)
    }
}

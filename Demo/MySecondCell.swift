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
        contentView.addSubview(logoImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.bounds.size
        let imageSize = logoImageView.image?.size ?? .zero
        let padding: CGFloat = 4
        logoImageView.frame = CGRect(x: padding,
                                     y: (frame.height - imageSize.height)/2,
                                     width: imageSize.width,
                                     height: imageSize.height)
        let offset = padding * 2 + imageSize.width
        optionLabel.frame = CGRect(x: offset,
                                   y: 0,
                                   width: size.width - offset,
                                   height: size.height)
    }
}

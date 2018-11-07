//
//  CheckboxCell.swift
//  Demo
//
//  Created by Aleksei Cherepanov on 31/10/2018.
//  Copyright © 2018 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

class CheckboxCell: DropDownCustomCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let executeSelection: () -> Void = { [weak self] in
            guard let `self` = self else { return }
            self.accessoryType = selected ? .checkmark : .none
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                executeSelection()
            })
        } else {
            executeSelection()
        }
        accessibilityTraits = selected ? .selected : .none
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let contentSize = optionLabel.systemLayoutSizeFitting(targetSize)
        let accessoryViewWidth:CGFloat = 40
        return CGSize(width: contentSize.width + accessoryViewWidth,
                      height: contentSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        optionLabel.frame = contentView.bounds
    }

}

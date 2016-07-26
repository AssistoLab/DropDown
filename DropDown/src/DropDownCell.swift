//
//  DropDownCellTableViewCell.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class DropDownCell: UITableViewCell {
		
	//UI
	@IBOutlet open weak var optionLabel: UILabel!
    @IBOutlet open weak var leftIcon: UIImageView!
    @IBOutlet open weak var rightIcon: UIImageView!
	
	var selectedBackgroundColor: UIColor?

}

//MARK: - UI

extension DropDownCell {
	
	override open func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = .clear
	}
	
	override open var isSelected: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override open var isHighlighted: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
		setSelected(highlighted, animated: animated)
	}
	
	override open func setSelected(_ selected: Bool, animated: Bool) {
		let executeSelection: () -> Void = { [weak self] in
			guard let `self` = self else { return }

			if let selectedBackgroundColor = self.selectedBackgroundColor {
				if selected {
					self.backgroundColor = selectedBackgroundColor
				} else {
					self.backgroundColor = .clear
				}
			}
		}
		
		if animated {
			UIView.animate(withDuration: 0.3, animations: {
				executeSelection()
			})
		} else {
			executeSelection()
		}
	}
    
    public func setupNoIcon() {
        leftIcon.removeFromSuperview()
        rightIcon.removeFromSuperview()
    }
    
    public func setupLeftIcon(icon: UIImage) {
        rightIcon.removeFromSuperview()
        leftIcon.image = icon
    }
    
    public func setupRightIcon(icon: UIImage) {
        leftIcon.removeFromSuperview()
        rightIcon.image = icon
    }
	
}
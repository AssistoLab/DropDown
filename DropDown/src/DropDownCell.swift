//
//  DropDownCellTableViewCell.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class DropDownCell: UITableViewCell {
		
	//UI
	@IBOutlet public weak var optionLabel: UILabel!
    @IBOutlet public weak var leftIcon: UIImageView!
    @IBOutlet public weak var rightIcon: UIImageView!
	
	var selectedBackgroundColor: UIColor?

}

//MARK: - UI

extension DropDownCell {
	
	override public func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = UIColor.clearColor()
	}
	
	override public var selected: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override public var highlighted: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override public func setHighlighted(highlighted: Bool, animated: Bool) {
		setSelected(highlighted, animated: animated)
	}
	
	override public func setSelected(selected: Bool, animated: Bool) {
		let executeSelection: () -> Void = { [unowned self] in
			if let selectedBackgroundColor = self.selectedBackgroundColor {
				if selected {
					self.backgroundColor = selectedBackgroundColor
				} else {
					self.backgroundColor = UIColor.clearColor()
				}
			}
		}
		
		if animated {
			UIView.animateWithDuration(0.3, animations: {
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
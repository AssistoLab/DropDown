//
//  DropDownCellTableViewCell.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal final class DropDownCell: UITableViewCell {
	
	//MARK: - Properties
	static let Nib = UINib(nibName: "DropDownCell", bundle: NSBundle(forClass: DropDownCell.self))
	
	//UI
	@IBOutlet weak var optionLabel: UILabel!
	
	var selectedBackgroundColor: UIColor?

}

//MARK: - UI

internal extension DropDownCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		backgroundColor = UIColor.clearColor()
	}
	
	override var selected: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override var highlighted: Bool {
		willSet {
			setSelected(newValue, animated: false)
		}
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
		setSelected(highlighted, animated: animated)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
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
	
}
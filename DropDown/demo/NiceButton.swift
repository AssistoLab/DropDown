//
//  NiceButton.swift
//  DropDown
//
//  Created by Kevin Hirsch on 06/06/16.
//  Copyright © 2016 Kevin Hirsch. All rights reserved.
//

import UIKit

class NiceButton: UIButton {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let view = UIView()
		view.backgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 1.0)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
		
		view.addConstraint(NSLayoutConstraint(
			item: view,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .Height,
			multiplier: 1,
			constant: 1
			)
		)
		
		addConstraint(NSLayoutConstraint(
			item: view,
			attribute: .Left,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Left,
			multiplier: 1,
			constant: 0
			)
		)
		
		addConstraint(NSLayoutConstraint(
			item: view,
			attribute: .Right,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Right,
			multiplier: 1,
			constant: 0
			)
		)
		
		addConstraint(NSLayoutConstraint(
			item: view,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Bottom,
			multiplier: 1,
			constant: 0
			)
		)
	}

}

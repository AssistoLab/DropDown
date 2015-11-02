//
//  ViewController.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var actionButton: UIButton!
	let dropDown = DropDown()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dropDown.dataSource = [
			"Car",
			"Motorcycle",
			"Van",
			"Truck",
			"Bus",
			"Bicycle",
			"Feet"
		]
		
		dropDown.selectionAction = { [unowned self] (index, item) in
			self.actionButton.setTitle(item, forState: .Normal)
		}
		
//		dropDown.cancelAction = { [unowned self] in
//			self.dropDown.selectRowAtIndex(-1)
//			self.actionButton.setTitle("Canceled", forState: .Normal)
//		}
		
		dropDown.anchorView = actionButton
		dropDown.bottomOffset = CGPoint(x: 0, y:actionButton.bounds.height)
//		dropDown.dismissMode = .Automatic
		
//		dropDown.selectRowAtIndex(3)
	}
	
	@IBAction func showOrDismiss(sender: AnyObject) {
		if dropDown.hidden {
			dropDown.show()
		} else {
			dropDown.hide()
		}
	}
	
	@IBAction func viewTapped() {
		view.endEditing(false)
	}
}
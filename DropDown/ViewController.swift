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
		
		dropDown.datasource = [
			"Car",
			"Motorcycle",
			"Van",
			"Truck",
			"Bus"
		]
		
		dropDown.selectionAction = { [unowned self] (string, index) in
			self.actionButton.setTitle(string, forState: .Normal)
		}
		
		dropDown.anchorView = actionButton
		dropDown.offset = CGPoint(x: 0, y:actionButton.bounds.height)
	}
	
	@IBAction func showOrDismiss(sender: AnyObject) {
		if dropDown.hidden {
			dropDown.show()
		} else {
			dropDown.hide()
		}
	}
}


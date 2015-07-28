//
//  ViewController.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var dropDown: DropDown!
	
	private var hidden = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dropDown.datasource = [
			"Car",
			"Motorcycle",
			"Van",
			"Truck",
			"Bus"
		]
		
		dropDown.selectionAction = { (string, index) in
			println("item \(string) at index \(index) selected")
		}
	}
	
	@IBAction func showOrDismiss(sender: AnyObject) {
		if hidden {
			dropDown.show()
		} else {
			dropDown.hide()
		}
		
		hidden = !hidden
	}
}


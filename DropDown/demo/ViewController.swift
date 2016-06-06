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
	@IBOutlet weak var rightBarButton: UIBarButtonItem!
	@IBOutlet weak var leftBarButton: UIBarButtonItem!

	let dropDown = DropDown()
	let dropDownLeft = DropDown()
	let dropDownRight = DropDown()

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDropDown()
		setupLeftBarButtonItemDropDown()
		setupRightBarButtonItemDropDown()
	}

	func setupDropDown() {
		dropDown.anchorView = actionButton

		// Will set a custom with instead of anchor view width
//		dropDown.width = 100
		
		dropDown.direction = .Bottom // The drop down will show below or will not be showed if not enough space.
		
		// By default, the dropdown will have its origin on the top left corner of its anchor view
		// So it will come over the anchor view and hide it completely
		// If you want to have the dropdown underneath your anchor view, you can do this:
		dropDown.bottomOffset = CGPoint(x: 0, y:actionButton.bounds.height)

		// You can also use localizationKeysDataSource instead. Check the docs.
		dropDown.dataSource = [
			"Car",
			"Motorcycle",
			"Van",
			"Truck",
			"Bus",
			"Bicycle",
			"Feet"
		]

		// Action triggered on selection
		dropDown.selectionAction = { [unowned self] (index, item) in
			self.actionButton.setTitle(item, forState: .Normal)
		}
		
		// Action triggered on dropdown cancelation (hide)
//		dropDown.cancelAction = { [unowned self] in
//			// You could for example deselect the selected item
//			self.dropDown.deselectRowAtIndexPath(self.dropDown.indexForSelectedRow)
//			self.actionButton.setTitle("Canceled", forState: .Normal)
//		}

		// Check the different dismiss modes in the docs.
//		dropDown.dismissMode = .Automatic

		// You can manually select a row if needed
//		dropDown.selectRowAtIndex(3)
	}

	func setupLeftBarButtonItemDropDown() {
		dropDownLeft.width = 100 // Comment this line to have a fitting width
		dropDownLeft.anchorView = leftBarButton
		dropDownLeft.dataSource = [
			"Menu 1",
			"Menu 2",
			"Menu 3",
			"Menu 4",
			"Menu 5",
		]
	}

	func setupRightBarButtonItemDropDown() {
//		dropDownRight.width = 100 // Comment this line to have a fitting width
		dropDownRight.anchorView = rightBarButton
		dropDownRight.dataSource = [
			"Short menu",
			"Long menu with the biggest text",
			"Medium size menu",
		]
	}

	@IBAction func showOrDismiss(sender: AnyObject) {
		if dropDown.hidden {
			dropDown.show()
		} else {
			dropDown.hide()
		}
	}

	@IBAction func showLeft(sender: AnyObject) {
		dropDownLeft.show()
	}

	@IBAction func showRight(sender: AnyObject) {
		dropDownRight.show()
	}

	@IBAction func viewTapped() {
		view.endEditing(false)
	}
}

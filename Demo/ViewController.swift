//
//  ViewController.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

class ViewController: UIViewController {

	//MARK: - Properties
	
	@IBOutlet weak var chooseArticleButton: UIButton!
	@IBOutlet weak var amountButton: UIButton!
	@IBOutlet weak var chooseButton: UIButton!
	@IBOutlet weak var centeredDropDownButton: UIButton!
	@IBOutlet weak var rightBarButton: UIBarButtonItem!
	let textField = UITextField()
	
	//MARK: - DropDown's
	
	let chooseArticleDropDown = DropDown()
	let amountDropDown = DropDown()
	let chooseDropDown = DropDown()
	let centeredDropDown = DropDown()
	let rightBarDropDown = DropDown()
	
	lazy var dropDowns: [DropDown] = {
		return [
			self.chooseArticleDropDown,
			self.amountDropDown,
			self.chooseDropDown,
			self.centeredDropDown,
			self.rightBarDropDown
		]
	}()
	
	//MARK: - Actions
	
	@IBAction func chooseArticle(sender: AnyObject) {
		chooseArticleDropDown.show()
	}
	
	@IBAction func changeAmount(sender: AnyObject) {
		amountDropDown.show()
	}
	
	@IBAction func choose(sender: AnyObject) {
		chooseDropDown.show()
	}
	
	@IBAction func showCenteredDropDown(sender: AnyObject) {
		centeredDropDown.show()
	}
	
	@IBAction func showBarButtonDropDown(sender: AnyObject) {
		rightBarDropDown.show()
	}
	
	@IBAction func changeDIsmissMode(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: dropDowns.forEach { $0.dismissMode = .Automatic }
		case 1: dropDowns.forEach { $0.dismissMode = .OnTap }
		default: break;
		}
	}
	
	@IBAction func changeDirection(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: dropDowns.forEach { $0.direction = .Any }
		case 1: dropDowns.forEach { $0.direction = .Bottom }
		case 2: dropDowns.forEach { $0.direction = .Top }
		default: break;
		}
	}
	
	@IBAction func changeUI(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: DropDown.setupDefaultAppearance()
		case 1: customizeDropDown(self)
		default: break;
		}
	}
	
	@IBAction func showKeyboard(sender: AnyObject) {
		textField.becomeFirstResponder()
	}
	
	@IBAction func hideKeyboard(sender: AnyObject) {
		view.endEditing(false)
	}
	
	func customizeDropDown(sender: AnyObject) {
		let appearance = DropDown.appearance()
		
		appearance.cellHeight = 60
		appearance.backgroundColor = UIColor(white: 1, alpha: 1)
		appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
//		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
		appearance.cornerRadius = 10
		appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
		appearance.shadowOpacity = 0.9
		appearance.shadowRadius = 25
		appearance.animationduration = 0.25
		appearance.textColor = .darkGrayColor()
//		appearance.textFont = UIFont(name: "Georgia", size: 14)
	}
	
	//MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupDropDowns()
		dropDowns.forEach { $0.dismissMode = .OnTap }
		dropDowns.forEach { $0.direction = .Any }
		
		view.addSubview(textField)
	}

	//MARK: - Setup
	
	func setupDropDowns() {
		setupChooseArticleDropDown()
		setupAmountDropDown()
		setupChooseDropDown()
		setupCenteredDropDown()
		setupRightBarDropDown()
	}
	
	func setupChooseArticleDropDown() {
		chooseArticleDropDown.anchorView = chooseArticleButton
		
		// Will set a custom with instead of anchor view width
		//		dropDown.width = 100
		
		// By default, the dropdown will have its origin on the top left corner of its anchor view
		// So it will come over the anchor view and hide it completely
		// If you want to have the dropdown underneath your anchor view, you can do this:
		chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: chooseArticleButton.bounds.height)
		
		// You can also use localizationKeysDataSource instead. Check the docs.
		chooseArticleDropDown.dataSource = [
			"iPhone SE | Black | 64G",
			"Samsung S7",
			"Huawei P8 Lite Smartphone 4G",
			"Asus Zenfone Max 4G",
			"Apple Watwh | Sport Edition"
		]
		
		// Action triggered on selection
		chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
			self.chooseArticleButton.setTitle(item, forState: .Normal)
		}
		
		// Action triggered on dropdown cancelation (hide)
		//		dropDown.cancelAction = { [unowned self] in
		//			// You could for example deselect the selected item
		//			self.dropDown.deselectRowAtIndexPath(self.dropDown.indexForSelectedRow)
		//			self.actionButton.setTitle("Canceled", forState: .Normal)
		//		}
		
		// You can manually select a row if needed
		//		dropDown.selectRowAtIndex(3)
	}
	
	func setupAmountDropDown() {
		amountDropDown.anchorView = amountButton
		
		// By default, the dropdown will have its origin on the top left corner of its anchor view
		// So it will come over the anchor view and hide it completely
		// If you want to have the dropdown underneath your anchor view, you can do this:
		amountDropDown.bottomOffset = CGPoint(x: 0, y: amountButton.bounds.height)
		
		// You can also use localizationKeysDataSource instead. Check the docs.
		amountDropDown.dataSource = [
			"10 €",
			"20 €",
			"30 €",
			"40 €",
			"50 €",
			"60 €",
			"70 €",
			"80 €",
			"90 €",
			"100 €",
			"110 €",
			"120 €"
		]
		
		// Action triggered on selection
		amountDropDown.selectionAction = { [unowned self] (index, item) in
			self.amountButton.setTitle(item, forState: .Normal)
		}
	}
	
	func setupChooseDropDown() {
		chooseDropDown.anchorView = chooseButton
		
		// By default, the dropdown will have its origin on the top left corner of its anchor view
		// So it will come over the anchor view and hide it completely
		// If you want to have the dropdown underneath your anchor view, you can do this:
		chooseDropDown.bottomOffset = CGPoint(x: 0, y: chooseButton.bounds.height)
		
		// You can also use localizationKeysDataSource instead. Check the docs.
		chooseDropDown.dataSource = [
			"Lorem ipsum dolor",
			"sit amet consectetur",
			"cadipisci en..."
		]
		
		// Action triggered on selection
		chooseDropDown.selectionAction = { [unowned self] (index, item) in
			self.chooseButton.setTitle(item, forState: .Normal)
		}
	}
	
	func setupCenteredDropDown() {
		// Not setting the anchor view makes the drop down centered on screen
//		centeredDropDown.anchorView = centeredDropDownButton
		
		// You can also use localizationKeysDataSource instead. Check the docs.
		centeredDropDown.dataSource = [
			"The drop down",
			"Is centered on",
			"the view because",
			"it has no anchor view defined.",
			"Click anywhere to dismiss."
		]
	}
	
	func setupRightBarDropDown() {
		rightBarDropDown.anchorView = rightBarButton
		
		// You can also use localizationKeysDataSource instead. Check the docs.
		rightBarDropDown.dataSource = [
			"Menu 1",
			"Menu 2",
			"Menu 3",
			"Menu 4"
		]
	}
}

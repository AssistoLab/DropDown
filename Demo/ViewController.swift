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
	
	@IBAction func chooseArticle(_ sender: AnyObject) {
		chooseArticleDropDown.show()
	}
	
	@IBAction func changeAmount(_ sender: AnyObject) {
		amountDropDown.show()
	}
	
	@IBAction func choose(_ sender: AnyObject) {
		chooseDropDown.show()
	}
	
	@IBAction func showCenteredDropDown(_ sender: AnyObject) {
		centeredDropDown.show()
	}
	
	@IBAction func showBarButtonDropDown(_ sender: AnyObject) {
		rightBarDropDown.show()
	}
	
	@IBAction func changeDIsmissMode(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: dropDowns.forEach { $0.dismissMode = .automatic }
		case 1: dropDowns.forEach { $0.dismissMode = .onTap }
		default: break;
		}
	}
	
	@IBAction func changeDirection(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: dropDowns.forEach { $0.direction = .any }
		case 1: dropDowns.forEach { $0.direction = .bottom }
		case 2: dropDowns.forEach { $0.direction = .top }
		default: break;
		}
	}
	
	@IBAction func changeUI(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0: setupDefaultDropDown()
		case 1: customizeDropDown(self)
		default: break;
		}
	}
	
	@IBAction func showKeyboard(_ sender: AnyObject) {
		textField.becomeFirstResponder()
	}
	
	@IBAction func hideKeyboard(_ sender: AnyObject) {
		view.endEditing(false)
	}
	
	func setupDefaultDropDown() {
		DropDown.setupDefaultAppearance()
		
		dropDowns.forEach {
			$0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
			$0.customCellConfiguration = nil
		}
	}
	
	func customizeDropDown(_ sender: AnyObject) {
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
		appearance.textColor = .darkGray
//		appearance.textFont = UIFont(name: "Georgia", size: 14)

		if #available(iOS 11.0, *) {
			appearance.setupMaskedCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
		}
		
		dropDowns.forEach {
			/*** FOR CUSTOM CELLS ***/
			$0.cellNib = UINib(nibName: "MyCell", bundle: nil)
			
			$0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
				guard let cell = cell as? MyCell else { return }
				
				// Setup your custom UI components
				cell.logoImageView.image = UIImage(named: "logo_\(index % 10)")
			}
			/*** ---------------- ***/
		}
	}
	
	//MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupDropDowns()
		dropDowns.forEach { $0.dismissMode = .onTap }
		dropDowns.forEach { $0.direction = .any }
		
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
		chooseArticleDropDown.selectionAction = { [weak self] (index, item) in
			self?.chooseArticleButton.setTitle(item, for: .normal)
		}
        
        chooseArticleDropDown.multiSelectionAction = { [weak self] (indices, items) in
            print("Muti selection action called with: \(items)")
            if items.isEmpty {
                self?.chooseArticleButton.setTitle("", for: .normal)
            }
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
		amountDropDown.selectionAction = { [weak self] (index, item) in
			self?.amountButton.setTitle(item, for: .normal)
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
		chooseDropDown.selectionAction = { [weak self] (index, item) in
			self?.chooseButton.setTitle(item, for: .normal)
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
        
        centeredDropDown.selectionAction = { [weak self] (index, item) in
            self?.centeredDropDownButton.setTitle(item, for: .normal)
        }
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

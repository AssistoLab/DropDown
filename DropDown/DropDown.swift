//
//  DropDown.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public typealias Index = Int
public typealias SelectionClosure = (String, Index) -> Void
public typealias ConfigurationClosure = (String) -> String

public class DropDown: UIView {
	
	//MARK: - Properties
	
	// There can be only one visible drop down at a time
	public static weak var VisibleDropDown: DropDown?
	
	//MARK: UI
	private let tableView = UITableView()
	private var heightConstraint: NSLayoutConstraint!
	
	//MARK: Appearance
	public override var backgroundColor: UIColor? {
		get {
			return tableView.backgroundColor
		}
		set {
			tableView.backgroundColor = newValue
		}
	}
	
	public dynamic var selectionBackgroundColor = Constant.UI.SelectionBackgroundColor {
		didSet {
			reloadAllComponents()
		}
	}
	
	public dynamic var textColor = UIColor.blackColor() {
		didSet {
			reloadAllComponents()
		}
	}
	
	public dynamic var textFont = UIFont.systemFontOfSize(15) {
		didSet {
			reloadAllComponents()
		}
	}
	
	//MARK: Content
	public var datasource = [String]() {
		didSet {
			reloadAllComponents()
		}
	}
	
	public var cellConfiguration: ConfigurationClosure?
	public var selectionAction: SelectionClosure!
	
	private var bounces: Bool {
		get {
			return tableView.bounces
		}
		set {
			tableView.bounces = newValue
		}
	}
	
	private var didSetupConstraints = false
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: CGRectZero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		setupUI()
	}
	
}

//MARK: - Setup

private extension DropDown {
	
	func setup() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = Constant.UI.RowHeight
		tableView.separatorColor = Constant.UI.SeparatorColor
		
		tableView.registerNib(DropDownCell.Nib, forCellReuseIdentifier: Constant.ReusableIdentifier.DropDownCell)
		
		updateConstraintsIfNeeded()
		setupUI()
	}
	
	func setupUI() {
		layer.cornerRadius = Constant.UI.CornerRadius
		super.backgroundColor = UIColor.clearColor()
		
		backgroundColor = Constant.UI.BackgroundColor
		tableView.layer.cornerRadius = Constant.UI.CornerRadius
		tableView.layer.masksToBounds = true
		bounces = false
		
		setHiddentState()
	}
	
}

//MARK - UI

extension DropDown {
	
	public override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}
		
		didSetupConstraints = true
		super.updateConstraints()
	}
	
	private func setupConstraints() {
		setTranslatesAutoresizingMaskIntoConstraints(false)
		
		addSubview(tableView)
		tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		addUniversalConstraints(format: "|[tableView]|", views: ["tableView": tableView])
		heightConstraint = NSLayoutConstraint(
			item: tableView,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: tableHeight())
		tableView.addConstraint(heightConstraint)
	}
	
	public override func layoutSubviews() {
		let shadowPath = UIBezierPath(rect: bounds)
		layer.masksToBounds = false
		layer.shadowColor = UIColor.darkGrayColor().CGColor
		layer.shadowOffset = CGSizeZero
		layer.shadowOpacity = 0.4
		layer.shadowPath = shadowPath.CGPath
		layer.shadowRadius = 8
	}
	
}

//MARK: - Actions

extension DropDown {
	
	public func show() {
		if let visibleDropDown = DropDown.VisibleDropDown {
			visibleDropDown.hide()
		}
		
		DropDown.VisibleDropDown = self
		
		UIView.animateWithDuration(Constant.Animation.Duration, delay: 0, options: Constant.Animation.EntranceOptions, animations: { [unowned self] in
			self.setShowedState()
			}, completion: nil)
	}
	
	public func hide() {
		DropDown.VisibleDropDown = nil
		
		UIView.animateWithDuration(Constant.Animation.Duration, delay: 0, options: Constant.Animation.ExitOptions, animations: { [unowned self] in
			self.setHiddentState()
			}, completion: nil)
	}
	
	private func setHiddentState() {
		alpha = 0
		transform = Constant.Animation.DownScaleTransform
	}
	
	private func setShowedState() {
		alpha = 1
		transform = CGAffineTransformIdentity
	}
	
}

//MARK: - UITableView

extension DropDown {
	
	public func reloadAllComponents() {
		tableView.reloadData()
		heightConstraint.constant = tableHeight()
		layoutIfNeeded()
	}
	
	public func selectRowAtIndex(index: Index) {
		tableView.selectRowAtIndexPath(
			NSIndexPath(forRow: index, inSection: 0),
			animated: false,
			scrollPosition: .Middle)
	}
	
	public func indexForSelectedRow() -> Index? {
		return tableView.indexPathForSelectedRow()?.row
	}
	
	public func selectedItem() -> String? {
		if let row = tableView.indexPathForSelectedRow()?.row {
			return datasource[row]
		} else {
			return nil
		}
	}
	
	public func tableHeight() -> CGFloat {
		return tableView.rowHeight * CGFloat(datasource.count)
	}
	
}

//MARK: - UITableViewDataSource - UITableViewDelegate

extension DropDown: UITableViewDataSource, UITableViewDelegate {
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return datasource.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Constant.ReusableIdentifier.DropDownCell, forIndexPath: indexPath) as! DropDownCell
		
		cell.optionLabel.textColor = textColor
		cell.optionLabel.font = textFont
		cell.selectedBackgroundColor = selectionBackgroundColor
		
		if let cellConfiguration = cellConfiguration {
			cell.optionLabel.text = cellConfiguration(datasource[indexPath.row])
		} else {
			cell.optionLabel.text = datasource[indexPath.row]
		}
		
		return cell
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let index = indexPath.row
		selectionAction(datasource[index], index)
	}
	
}
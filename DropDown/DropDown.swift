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
	private let dismissableView = UIView()
	private let tableViewContainer = UIView()
	private let tableView = UITableView()
	
	// View to which the drop down is binded
	public var anchorView: UIView! {
		didSet {
			setNeedsUpdateConstraints()
		}
	}
	
	// Anchor or origin point relative to anchorView. Default to CGPointZero
	public var offset: CGPoint? {
		didSet {
			setNeedsUpdateConstraints()
		}
	}
	
	// Desired width. Defaults to anchorView width - offset.x
	public var width: CGFloat? {
		didSet {
			setNeedsUpdateConstraints()
		}
	}
	
	//MARK: Constraints
	private var heightConstraint: NSLayoutConstraint!
	private var widthConstraint: NSLayoutConstraint!
	private var xConstraint: NSLayoutConstraint!
	private var yConstraint: NSLayoutConstraint!
	
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
		
		tableView.registerNib(DropDownCell.Nib, forCellReuseIdentifier: Constant.ReusableIdentifier.DropDownCell)
		
		updateConstraintsIfNeeded()
		setupUI()
	}
	
	func setupUI() {
		super.backgroundColor = UIColor.clearColor()
		
		tableViewContainer.layer.cornerRadius = Constant.UI.CornerRadius
		tableViewContainer.layer.masksToBounds = false
		tableViewContainer.layer.shadowColor = UIColor.darkGrayColor().CGColor
		tableViewContainer.layer.shadowOffset = CGSizeZero
		tableViewContainer.layer.shadowOpacity = 0.3
		tableViewContainer.layer.shadowRadius = 5
		
		backgroundColor = Constant.UI.BackgroundColor
		tableView.rowHeight = Constant.UI.RowHeight
		tableView.separatorColor = Constant.UI.SeparatorColor
		tableView.layer.cornerRadius = Constant.UI.CornerRadius
		tableView.layer.masksToBounds = true
		tableView.scrollEnabled = false
		
		setHiddentState()
		hidden = true
	}
	
}

//MARK - UI

extension DropDown {
	
	public override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}
		
		didSetupConstraints = true
		
		xConstraint.constant = (anchorView?.windowFrame?.minX ?? 0) + (offset?.x ?? 0)
		yConstraint.constant = (anchorView?.windowFrame?.minY ?? 0) + (offset?.y ?? 0)
		widthConstraint.constant = width ?? (anchorView?.bounds.width ?? 0) - (offset?.x ?? 0)
		heightConstraint.constant = tableHeight()
		
		super.updateConstraints()
	}
	
	private func setupConstraints() {
		setTranslatesAutoresizingMaskIntoConstraints(false)
		
		// Dismissable view
		addSubview(dismissableView)
		dismissableView.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		addUniversalConstraints(format: "|[dismissableView]|", views: ["dismissableView": dismissableView])
		
		
		// Table view container
		addSubview(tableViewContainer)
		tableViewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		xConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .Leading,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Leading,
			multiplier: 1,
			constant: 0)
		addConstraint(xConstraint)
		
		yConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .Top,
			relatedBy: .Equal,
			toItem: self,
			attribute: .Top,
			multiplier: 1,
			constant: 0)
		addConstraint(yConstraint)
		
		widthConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .Width,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: 0)
		tableViewContainer.addConstraint(widthConstraint)
		
		heightConstraint = NSLayoutConstraint(
			item: tableViewContainer,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: 0)
		tableViewContainer.addConstraint(heightConstraint)
		
		// Table view
		tableViewContainer.addSubview(tableView)
		tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
		
		tableViewContainer.addUniversalConstraints(format: "|[tableView]|", views: ["tableView": tableView])
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		let shadowPath = UIBezierPath(rect: tableViewContainer.bounds)
		tableViewContainer.layer.shadowPath = shadowPath.CGPath
	}
	
}

//MARK: - Actions

extension DropDown {
	
	public func show() {
		if let visibleDropDown = DropDown.VisibleDropDown {
			visibleDropDown.hide()
		}
		
		DropDown.VisibleDropDown = self
		
		setNeedsUpdateConstraints()
		
		let visibleWindow = UIWindow().visibleWindow
		visibleWindow?.addSubview(self)
		visibleWindow?.bringSubviewToFront(self)
		
		self.setTranslatesAutoresizingMaskIntoConstraints(false)
		visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])
		layoutIfNeeded()
		layoutSubviews()
		
		hidden = false
		
		tableViewContainer.transform = Constant.Animation.DownScaleTransform
		
		UIView.animateWithDuration(
			Constant.Animation.Duration,
			delay: 0,
			options: Constant.Animation.EntranceOptions,
			animations: { [unowned self] in
				self.setShowedState()
			},
			completion: nil)
	}
	
	public func hide() {
		DropDown.VisibleDropDown = nil
		
		UIView.animateWithDuration(
			Constant.Animation.Duration,
			delay: 0,
			options: Constant.Animation.ExitOptions,
			animations: { [unowned self] in
				self.setHiddentState()
			},
			completion: { [unowned self] finished in
				self.hidden = true
				self.removeFromSuperview()
			})
	}
	
	private func setHiddentState() {
		alpha = 0
	}
	
	private func setShowedState() {
		alpha = 1
		tableViewContainer.transform = CGAffineTransformIdentity
	}
	
}

//MARK: - UITableView

extension DropDown {
	
	public func reloadAllComponents() {
		tableView.reloadData()
		setNeedsUpdateConstraints()
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
		hide()
	}
	
}
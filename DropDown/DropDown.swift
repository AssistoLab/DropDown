//
//  DropDown.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public typealias Index = Int
public typealias Closure = () -> Void
public typealias SelectionClosure = (Index, String) -> Void
public typealias ConfigurationClosure = (String) -> String

public final class DropDown: UIView {
	
	/*
	handle iOS 7 landscape mode
	*/
	
	public enum DismissMode {
		
		case OnTap // a tap outside the drop down from the user is needed to dismiss
		case Automatic // automatic dismiss when user interacts with anything else than the drop down
		case Manual // not dismissable by the user
		
	}
	
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
	
	public dynamic var selectionBackgroundColor = UI.SelectionBackgroundColor {
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
	public var dataSource = [String]() {
		didSet {
			reloadAllComponents()
		}
	}
	
	private var selectedRowIndex: Index = -1
	
	public var cellConfiguration: ConfigurationClosure?
	public var selectionAction: SelectionClosure!
	public var cancelAction: Closure?
	
	public var dismissMode = DismissMode.OnTap {
		willSet {
			if newValue == .OnTap {
				let gestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissableViewTapped")
				dismissableView.addGestureRecognizer(gestureRecognizer)
			} else if let gestureRecognizer = dismissableView.gestureRecognizers?.first as? UIGestureRecognizer {
				dismissableView.removeGestureRecognizer(gestureRecognizer)
			}
		}
	}
	
	private var didSetupConstraints = false
	
	//MARK: - Init's
	
	deinit {
		stopListeningToNotifications()
	}
	
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
	
}

//MARK: - Setup

private extension DropDown {
	
	func setup() {
		updateConstraintsIfNeeded()
		setupUI()
		
		dismissMode = .OnTap
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.registerNib(DropDownCell.Nib, forCellReuseIdentifier: ReusableIdentifier.DropDownCell)
		
		startListeningToKeyboard()
	}
	
	func setupUI() {
		super.backgroundColor = UIColor.clearColor()
		
		tableViewContainer.layer.masksToBounds = false
		tableViewContainer.layer.cornerRadius = UI.CornerRadius
		tableViewContainer.layer.shadowColor = UI.Shadow.Color
		tableViewContainer.layer.shadowOffset = UI.Shadow.Offset
		tableViewContainer.layer.shadowOpacity = UI.Shadow.Opacity
		tableViewContainer.layer.shadowRadius = UI.Shadow.Radius
		
		backgroundColor = UI.BackgroundColor
		tableView.rowHeight = UI.RowHeight
		tableView.separatorColor = UI.SeparatorColor
		tableView.layer.cornerRadius = UI.CornerRadius
		tableView.layer.masksToBounds = true
		
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
		
		let height = tableHeight()
		var offScreenHeight: CGFloat = 0
		
		if let window = UIWindow.visibleWindow() {
			let maxY = height + yConstraint.constant
			let windowMaxY = window.bounds.maxY - UI.HeightPadding
			let keyboardListener = KeyboardListener.sharedInstance
			let keyboardMinY = keyboardListener.keyboardFrame.minY - UI.HeightPadding
			
			if keyboardListener.isVisible && maxY > keyboardMinY {
				offScreenHeight = abs(maxY - keyboardMinY)
			} else if maxY > windowMaxY {
				offScreenHeight = abs(maxY - windowMaxY)
			}
		}
		
		heightConstraint.constant = height - offScreenHeight
		tableView.scrollEnabled = offScreenHeight > 0
		
		dispatch_async(dispatch_get_main_queue(), { [unowned self] in
			self.tableView.flashScrollIndicators()
			})
		
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
		
		// When orientation changes, layoutSubviews is called
		// We update the constraint to update the position
		setNeedsUpdateConstraints()
		
		let shadowPath = UIBezierPath(rect: tableViewContainer.bounds)
		tableViewContainer.layer.shadowPath = shadowPath.CGPath
	}
	
}

//MARK: - Actions

extension DropDown {
	
	public func show() {
		if let visibleDropDown = DropDown.VisibleDropDown {
			visibleDropDown.cancel()
		}
		
		DropDown.VisibleDropDown = self
		
		setNeedsUpdateConstraints()
		
		let visibleWindow = UIWindow.visibleWindow()
		visibleWindow?.addSubview(self)
		visibleWindow?.bringSubviewToFront(self)
		
		self.setTranslatesAutoresizingMaskIntoConstraints(false)
		visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])
		layoutIfNeeded()
		layoutSubviews()
		
		hidden = false
		tableViewContainer.transform = Animation.DownScaleTransform
		
		UIView.animateWithDuration(
			Animation.Duration,
			delay: 0,
			options: Animation.EntranceOptions,
			animations: { [unowned self] in
				self.setShowedState()
			},
			completion: nil)
		
		selectRowAtIndex(selectedRowIndex)
	}
	
	public func hide() {
		DropDown.VisibleDropDown = nil
		
		UIView.animateWithDuration(
			Animation.Duration,
			delay: 0,
			options: Animation.ExitOptions,
			animations: { [unowned self] in
				self.setHiddentState()
			},
			completion: { [unowned self] finished in
				self.hidden = true
				self.removeFromSuperview()
			})
	}
	
	private func cancel() {
		hide()
		cancelAction?()
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
		selectedRowIndex = index
		
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
			return dataSource[row]
		} else {
			return nil
		}
	}
	
	public func tableHeight() -> CGFloat {
		return tableView.rowHeight * CGFloat(dataSource.count)
	}
	
}

//MARK: - UITableViewDataSource - UITableViewDelegate

extension DropDown: UITableViewDataSource, UITableViewDelegate {
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(ReusableIdentifier.DropDownCell, forIndexPath: indexPath) as! DropDownCell
		
		cell.optionLabel.textColor = textColor
		cell.optionLabel.font = textFont
		cell.selectedBackgroundColor = selectionBackgroundColor
		
		if let cellConfiguration = cellConfiguration {
			cell.optionLabel.text = cellConfiguration(dataSource[indexPath.row])
		} else {
			cell.optionLabel.text = dataSource[indexPath.row]
		}
		
		return cell
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		cell.selected = indexPath.row == selectedRowIndex
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedRowIndex = indexPath.row
		selectionAction(selectedRowIndex, dataSource[selectedRowIndex])
		hide()
	}
	
}

//MARK: - Auto dismiss

extension DropDown {
	
	public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, withEvent: event)
		
		if dismissMode == .Automatic && view === dismissableView {
			cancel()
			return nil
		} else {
			return view
		}
	}
	
	@objc
	func dismissableViewTapped() {
		cancel()
	}
	
}

//MARK: - Keyboard events

private extension DropDown {
	
	func startListeningToKeyboard() {
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "keyboardUpdate",
			name: UIKeyboardDidShowNotification,
			object: nil)
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "keyboardUpdate",
			name: UIKeyboardDidHideNotification,
			object: nil)
	}
	
	func stopListeningToNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	@objc
	func keyboardUpdate() {
		setNeedsUpdateConstraints()
	}
	
}
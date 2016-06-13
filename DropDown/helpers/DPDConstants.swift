//
//  Constants.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal struct DPDConstant {

	internal struct KeyPath {

		static let Frame = "frame"

	}

	internal struct ReusableIdentifier {

		static let DropDownCell = "DropDownCell"

	}

	internal struct UI {

		static let TextColor = UIColor.blackColor()
		static let TextFont = UIFont.systemFontOfSize(15)
		static let BackgroundColor = UIColor(white: 0.94, alpha: 1)
		static let SelectionBackgroundColor = UIColor(white: 0.89, alpha: 1)
		static let SeparatorColor = UIColor.clearColor()
		static let CornerRadius: CGFloat = 2
		static let RowHeight: CGFloat = 44
		static let HeightPadding: CGFloat = 20

		struct Shadow {

			static let Color = UIColor.darkGrayColor()
			static let Offset = CGSize.zero
			static let Opacity: Float = 0.4
			static let Radius: CGFloat = 8

		}

	}

	internal struct Animation {

		static let Duration = 0.15
		static let EntranceOptions: UIViewAnimationOptions = [.AllowUserInteraction, .CurveEaseOut]
		static let ExitOptions: UIViewAnimationOptions = [.AllowUserInteraction, .CurveEaseIn]
		static let DownScaleTransform = CGAffineTransformMakeScale(0.9, 0.9)

	}

}

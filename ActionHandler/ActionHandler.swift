/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

open class ActionHandler: UIObject {

	func reportMissingControlState(_ type: ControlState.Type, for item: Item) {
		print("Missing control state \(type) for \(item)")
	}
}

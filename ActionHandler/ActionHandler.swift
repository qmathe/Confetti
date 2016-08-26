/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class ActionHandler: UIObject {

	func reportMissingControlState(type: ControlState.Type, for item: Item) {
		print("Missing control state \(type) for \(item)")
	}
}

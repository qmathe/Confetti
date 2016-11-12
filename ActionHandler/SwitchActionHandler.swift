/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

open class SwitchActionHandler: ActionHandler {
	
	/// Updates the current state and emits a SwitchStatus event.
	///
	/// Will be called when the switch is clicked or swiped.
	func toggle(_ item: Item, toStatus: Int) {
		guard let state = item.controlState as? SwitchState else {
			reportMissingControlState(SwitchState.self, for: item)
			return
		}
		state.status = SwitchStatus(rawValue: toStatus)!
		item.eventCenter.send(state.status, from: item)
	}
}

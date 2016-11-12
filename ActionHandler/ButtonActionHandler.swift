/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

open class ButtonActionHandler: ActionHandler {

	/// Emits a tap event.
	///
	/// Will be called when the button is touched or clicked.
	func tap(_ item: Item) {
		item.eventCenter.send(Tap(count: 1), from: item)
	}
}

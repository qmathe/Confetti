/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

/**
To detect when the user stops to drag the slider thumb, observe when the editing
ends.

Note: there is no continuous property, but you can observe the editing cycle 
(begin/change/end) to get the same results.
*/
public class SliderActionHandler: ActionHandler {
	
	/// Updates the current value and emits a VectorFloat event representing the 
	/// new value.
	///
	/// Will be called when the slider is clicked, dragged or panned.
	func pan(item: Item, toValue: VectorFloat) {
		guard let state = item.controlState as? SliderState else {
			reportMissingControlState(SwitchState.self, for: item)
			return
		}
		state.currentValue = toValue
		item.eventCenter.send(state.currentValue, from: item)
	}
}

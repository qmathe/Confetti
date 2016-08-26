/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

extension Item {

	func reactTo(sender: NSSlider) {
		(actionHandlers.first as? SliderActionHandler)?.pan(self, toValue: VectorFloat(sender.floatValue))
	}
}

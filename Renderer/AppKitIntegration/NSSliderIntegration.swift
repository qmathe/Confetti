/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation
import Tapestry

extension Item {

	func reactTo(_ sender: NSSlider) {
		(controlState as? SliderState)?.currentValue.value = VectorFloat(sender.floatValue)
	}
}

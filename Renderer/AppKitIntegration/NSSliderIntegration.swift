/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

extension Slider {

	dynamic func reactTo(sender: NSSlider) {
		pan(VectorFloat(sender.floatValue))
	}
}

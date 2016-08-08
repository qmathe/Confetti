/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

class Label: Item {

	internal override func render(renderer: Renderer) {
		renderer.renderLabel(self)
	}
}
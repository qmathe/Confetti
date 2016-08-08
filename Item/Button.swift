/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */


import Foundation

class Button: Item {

	internal override func render(renderer: Renderer) {
		renderer.renderButton(self)
	}
}

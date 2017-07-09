/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation

class App {
	let presentation: Presentation
	let renderer: Renderer
	var node: RenderedNode?
	
	init(presentation: Presentation, renderer: Renderer) {
		self.presentation = presentation
		self.renderer = renderer
	}

	func update() {
		if let presentation = presentation.update() {
			node = renderer.renderItem(presentation.item)
		}
	}
}

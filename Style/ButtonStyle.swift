/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class ButtonStyle: Style, RenderableAspect {

	func render(item: Item, with renderer: Renderer) -> RenderedNode {
		return renderer.renderButton(item)
	}
}

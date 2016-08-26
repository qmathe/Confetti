/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class SwitchStyle: Style, RenderableAspect {

	func render(item: Item, with renderer: Renderer) -> RenderedNode {
		return renderer.renderSwitch(item)
	}
}

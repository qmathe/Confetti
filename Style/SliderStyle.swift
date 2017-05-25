/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import Tapestry

open class SliderStyle: Style, RenderableAspect {

	/// The default height when rendering the slider as a Confetti control.
	///
	/// When rendering with other UI toolkits, the final height will vary.
	open static var defaultHeight: VectorFloat = 18

	func render(_ item: Item, with renderer: Renderer) -> RenderedNode {
		return renderer.renderSlider(item)
	}
}

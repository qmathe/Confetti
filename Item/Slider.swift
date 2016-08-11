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
public class Slider: Item {

	public var minValue: VectorFloat = 0
	public var maxValue: VectorFloat = 0
	public var initialValue: VectorFloat = 0
	/// The default height when rendering the slider as a Confetti control.
	///
	/// When rendering with other UI toolkits, the final height will vary.
	public var defaultHeight: VectorFloat = 18

	// TODO: Make frame optional once we support sizeToFit()

	public init(orientation: Orientation, length: VectorFloat, min: VectorFloat = 0, max: VectorFloat, initial: VectorFloat,
		target: AnyObject? = nil, action: Selector? = nil, forProperty property: String = "", ofRepresentedObject representedObject: AnyObject? = nil) {
		
		let width = orientation == .Horizontal ? length : defaultHeight
		let height = orientation == .Horizontal ? defaultHeight : length

		super.init(frame: Rect(x: 0, y: 0, width: width, height: height))

		// TODO: Support target/action and property
		self.minValue = min
		self.maxValue = max
		self.initialValue = initial
		self.representedObject = representedObject
	}

	public override func render(renderer: Renderer) -> RenderedNode {
		return renderer.renderSlider(self)
	}
}

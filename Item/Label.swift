/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class Label: Item {

	public var text = ""
	
	// TODO: Make frame optional once we support sizeToFit()
	public init(frame: Rect, text: String = "") {
		super.init(frame: frame)
		self.text = text
	}

	public override func render(renderer: Renderer) -> RenderedNode  {
		return renderer.renderLabel(self)
	}
}
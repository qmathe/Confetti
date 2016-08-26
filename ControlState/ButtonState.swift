/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class ButtonState: ControlState {

	public var text = ""
	
	public init(text: String = "", objectGraph: ObjectGraph) {
		super.init(objectGraph: objectGraph)
		self.text = text
	}
}
